//
//  API.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import Foundation
import Combine

enum RosesAreRedError: Error {
    case nonHTTPResponse
    case requestFailed(Int)
    case networkingError(URLError)
    case decodingError(DecodingError)

    func prettyErrorMessage() -> String {
        switch self {
        case .nonHTTPResponse:
            return "Error: received non-HTTP response."
        case .requestFailed(_):
            return "Error: request failed."
        case .networkingError(_):
            return "Error: networking issue."
        case .decodingError(_):
            return "Error: unable to decode HTTP response."
        }
    }
}

class API {
    let session: URLSession
    let baseURL = URL(string: "http://demo8766030.mockable.io")!

    static let shared = API()

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func getOrders() -> AnyPublisher<[Order], RosesAreRedError> {
        getObject(ofType: [Order].self, atPath: "/orders")
    }


    func getCustomers() -> AnyPublisher<[Customer], RosesAreRedError> {
        getObject(ofType: [Customer].self, atPath: "/customers")
    }

    func getObject<T: Decodable>(ofType type: T.Type, atPath path: String) -> AnyPublisher<T, RosesAreRedError> {
        let url = baseURL.appendingPathComponent(path)

        let request = URLRequest(url: url)

        return session.dataTaskPublisher(for: request)
            .mapError { RosesAreRedError.networkingError($0) }
            .tryMap {
                guard let http = $0.response as? HTTPURLResponse else {
                    throw RosesAreRedError.nonHTTPResponse
                }
                guard http.statusCode == 200 else {
                    throw RosesAreRedError.requestFailed(http.statusCode)
                }
                return $0.data
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? DecodingError {
                    return .decodingError(error)
                } else {
                    return error as! RosesAreRedError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
