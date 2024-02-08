//
//  EndPoint.swift
//
//
//  Created by Mohamed Hamdouchi on 2/8/24.
//

import Foundation

public protocol EndPoint {
	var scheme: String { get }
	var host: String { get }
	var path: String { get }
	var method: RequestMethod { get }
	var header: [String: String] { get }
	var body: Encodable? { get }
}

extension EndPoint {
	var scheme: String {
		return "https"
	}

	var header: [String: String] {
		[:]
	}
}
