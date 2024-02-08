//
//  NetworkService.swift
//
//
//  Created by Mohamed Hamdouchi on 2/8/24.
//

import Foundation
import Combine

public final class NetworkService: Networkable {
	public func sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, NetworkError>) -> Void) {
		
		guard let urlRequest = createRequest(endPoint: endpoint) else {
			return
		}
		let urlTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard error == nil else {
				resultHandler(.failure(.invalidURL))
				return
			}
			guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
				resultHandler(.failure(.unexpectedStatusCode))
				return
			}
			guard let data = data else {
				resultHandler(.failure(.unknown(nil)))
				return
			}
			guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
				resultHandler(.failure(.decode))
				return
			}
			resultHandler(.success(decodedResponse))
		}
		urlTask.resume()
	}
	
	
	public func sendRequest<T>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError> where T : Decodable {
		guard let urlRequest = createRequest(endPoint: endpoint) else {
			precondition(false, "Failed URLRequest")
		}
		return URLSession.shared.dataTaskPublisher(for: urlRequest)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.tryMap { data, response -> Data in
				guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
					throw NetworkError.invalidURL
				}
				return data
			}
			.decode(type: T.self, decoder: JSONDecoder())
			.mapError { error -> NetworkError in
				if error is DecodingError {
					return NetworkError.decode
				} else if let error = error as? NetworkError {
					return error
				} else {
					return NetworkError.unknown(nil)
				}
			}
			.eraseToAnyPublisher()
	}
	
	public func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T {
		guard let urlRequest = createRequest(endPoint: endpoint) else {
			throw NetworkError.decode
		}
		return try await withCheckedThrowingContinuation { continuation in
			let task = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
				.dataTask(with: urlRequest) { data, response, _ in
					guard response is HTTPURLResponse else {
						continuation.resume(throwing: NetworkError.invalidURL)
						return
					}
					guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
						continuation.resume(throwing:
												NetworkError.unexpectedStatusCode)
						return
					}
					guard let data = data else {
						continuation.resume(throwing: NetworkError.unknown(nil))
						return
					}
					guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
						continuation.resume(throwing: NetworkError.decode)
						return
					}
					continuation.resume(returning: decodedResponse)
				}
			task.resume()
		}
	}
	
	public init() {}
}
