//
//  APIManaging.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Moya
import Combine

// APIManaging is a protocol that defines the methods for making network requests and handling responses.
protocol APIManaging {

    /// Makes a network request and returns raw `Data` as a publisher.
    /// - Parameter target: The target for the network request, which conforms to `TargetType`.
    /// - Returns: A `Publisher` that emits the raw `Data` from the network response or an error.
    func request(target: TargetType) -> AnyPublisher<Data, Error>

    /// Makes a network request and decodes the response into a specific type.
    /// - Parameters:
    ///   - target: The target for the network request, which conforms to `TargetType`.
    ///   - responseType: The type that the response should be decoded into (conforms to `Decodable`).
    ///   - jsonDecoder: An optional custom `JSONDecoder` for decoding the response. If nil, a default decoder is used.
    /// - Returns: A `Publisher` that emits the decoded response object of type `T` or an error.
    func request<T: Decodable>(target: TargetType, responseType: T.Type, jsonDecoder: JSONDecoder?) -> AnyPublisher<T, Error>

    /// Makes a network request and returns the response as a dictionary.
    /// - Parameter target: The target for the network request, which conforms to `TargetType`.
    /// - Returns: A `Publisher` that emits a dictionary (`[String: Any]`) as the response or an error.
    func requestResponse(target: TargetType) -> AnyPublisher<[String: Any], Error>
}
