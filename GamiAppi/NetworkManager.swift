//
//  NetworkManager.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/15/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import Foundation

/// Network Error
struct NetworkError: Error {
    var response: String
    var statusCode: Int
}

/// Apis
enum Apis {
    case webView
    case botConfiguration
    case authApi
    case trackTask
    case markRedeemDone
    
    var path: String {
        if GamiphySDK.shared.options.debugEnabled {
            switch self {
            case .webView:
                return "https://%@.bot.dev.gamiphy.co/"
            case .botConfiguration:
                return "https://api.dev.gamiphy.co/bots/api/v1/%@/options"
            case .authApi:
                return "https://api.dev.gamiphy.co/clients/api/v1/bot/%@/user"
            case .trackTask:
                return "https://api.dev.gamiphy.co/bot-event/api/v1/bot/%@/track"
            case .markRedeemDone:
                return "https://api.dev.gamiphy.co/bots/api/v1/%@/package/%@/redeem"
            }
        } else {
            switch self {
            case .webView:
                return "https://%@.bot.gamiphy.co/"
            case .botConfiguration:
                return "https://api.gamiphy.co/bots/api/v1/%@/options"
            case .authApi:
                return "https://api.gamiphy.co/clients/api/v1/bot/%@/user"
            case .trackTask:
                return "https://api.gamiphy.co/bot-event/api/v1/bot/%@/track"
            case .markRedeemDone:
                return "https://api.gamiphy.co/bots/api/v1/%@/package/%@/redeem"
            }
        }
    }
}

/// Network Manager
class NetworkManager {
    
    /**
     Request
     - Parameter url: The request url.
     - Parameter method: The request methd.
     - Parameter keyPath: The keyPath to get data for.
     - Parameter parameters: The request parameters.
     - Parameter completion: The completion block for the request.
     */
    func request<T: Decodable>(url: String, method: String, keyPath: String, parameters: [String: Any] = [:], headers: [String: String] = [:], completion: @escaping (_ result: Result<T, Error>) -> Void) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.request(urlRequest: request, keyPath: keyPath, completion: completion)
    }
    
    /**
     Request url request
     - Parameter urlRequest: The url request to call.
     - Parameter keyPath: The keyPath to get data for.
     - Parameter completion: The completion block.
     */
    func request<T: Decodable>(urlRequest: URLRequest, keyPath: String, completion: @escaping (_ result: Result<T, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    
                    // Check for fundamental
                    completion(Result.failure(error ?? NetworkManager() as! Error))
                    return
            }
            
            completion(self.getDecodableSerializer(byKeyPath: keyPath, data: data, response: response, decoder: JSONDecoder()))
        }
        
        task.resume()
    }
    
    /**
     Decodable Object Serializer
     - Parameter keyPath:           The keyPath where object decoding should be performed. Default: `nil`.
     - Parameter decoder:           The decoder that performs the decoding of JSON into semantic `Decodable` type. Default: `JSONDecoder()`.
     - Returns:                     Result object.
     */
    func getDecodableSerializer<T: Decodable>(byKeyPath keyPath: String, data: Data, response: HTTPURLResponse, decoder: JSONDecoder) -> Result<T, Error> {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            // Check if contains errors
            if let dataObject = json as? NSDictionary, let error = dataObject.value(forKey: "error") as? String {
                return .failure(NSError(domain: error, code: response.statusCode, userInfo: [:]))
            }
            
            // Check if key path is empty
            if keyPath.isEmpty {
                do {
                    let data = try JSONSerialization.data(withJSONObject: json)
                    let object = try decoder.decode(T.self, from: data)
                    return .success(object)
                } catch {
                    return .failure(error)
                }
            }
            
            if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                if let value = nestedJson as? T {
                    return .success(value)
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: nestedJson)
                    let object = try decoder.decode(T.self, from: data)
                    return .success(object)
                }
                catch {
                    return .failure(error)
                }
            } else {
                return .failure(NSError(domain: "failed to serialize data", code: response.statusCode, userInfo: [:]))
            }
        } catch {
            return .failure(error)
        }
    }
}
