//
//  NetworkError.swift
//
//
//  Created by Mohamed Hamdouchi on 2/8/24.
//

import Foundation

public enum NetworkError: Error {
	case decode
	case invalidURL
	case badRequest(_ message: String)
	case noResponse
	case unauthorized
	case unexpectedStatusCode
	case unknown(_ underlayingError: Error?)
}

extension NetworkError: CustomStringConvertible {
	public var description: String {
		switch self {
		case .decode: return "Decode error"
		case .invalidURL: return "Invalid URL error"
		case let .badRequest(message): return message
		case .noResponse: return "No response error"
		case .unauthorized: return "Session expired error"
		case .unexpectedStatusCode: return "Unexpected status code error"
		case let .unknown(error):
			if let error = error {
				return error.localizedDescription
			} else {
				return "Unknown error"
			}
		}
	}
}

