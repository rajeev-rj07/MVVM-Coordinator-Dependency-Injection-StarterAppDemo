//
//  APIManager.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Moya
import Combine

// APIManager is responsible for handling network requests using Moya and Combine.
// It conforms to the APIManaging protocol.
final class APIManager: APIManaging {

    // Moya provider to handle requests for any TargetType using MultiTarget.
    let provider = MoyaProvider<MultiTarget>()

    // Sends a network request and returns the raw Data in a publisher.
    // - Parameters:
    //   - target: The target API endpoint (conforming to TargetType).
    // - Returns: A publisher that emits the Data from the response or an Error if the request fails.
    func request(target: TargetType) -> AnyPublisher<Data, Error> {
        provider.requestPublisher(MultiTarget(target))  // Wraps the target in MultiTarget for flexibility.
            .map({ $0.data })  // Extracts the raw Data from the response.
            .mapError({ moyaError in  // Maps the Moya error to a generic Error.
                moyaError as Error
            })
            .eraseToAnyPublisher()  // Erases the publisher type for flexibility in handling the result.
    }

    // Sends a network request and decodes the response into a Decodable object.
    // - Parameters:
    //   - target: The target API endpoint.
    //   - responseType: The expected Decodable type of the response.
    //   - jsonDecoder: Optional custom JSONDecoder (uses default if nil).
    // - Returns: A publisher that emits the decoded object or an Error if the request/decoding fails.
    func request<T: Decodable>(target: TargetType, responseType: T.Type, jsonDecoder: JSONDecoder?) -> AnyPublisher<T, Error> {
        request(target: target)  // Reuses the basic request method to get Data.
            .decode(type: responseType, decoder: jsonDecoder ?? JSONDecoder())  // Decodes the Data into the specified type.
            .eraseToAnyPublisher()
    }

    // Sends a network request and tries to map the response into a JSON dictionary ([String: Any]).
    // - Parameters:
    //   - target: The target API endpoint.
    // - Returns: A publisher that emits a dictionary representation of the JSON response or an Error.
    func requestResponse(target: TargetType) -> AnyPublisher<[String: Any], Error> {
        provider.requestPublisher(MultiTarget(target))
            .tryMap { response -> [String: Any] in  // Tries to map the response to a JSON dictionary.
                if let json = try? response.mapJSON() as? [String: Any] {
                    return json
                } else {
                    throw NSError(domain: "Invalid JSON format", code: 0, userInfo: nil)  // Throws an error if mapping fails.
                }
            }
            .mapError { moyaError in moyaError as Error }  // Maps any Moya error to a generic Error.
            .eraseToAnyPublisher()
    }
}
