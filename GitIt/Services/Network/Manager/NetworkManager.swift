//
//  NetworkManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation

class NetworkManager {
    
    static let standard = NetworkManager()
    private let urlSession: URLSession!
    
    // MARK: - Initialisation
    
    private init() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        urlSession = URLSession(configuration: urlSessionConfiguration)
    }
    
    // MARK: - GET Request Methods
    
    func GETRequest(url: URL, completion: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: "GET")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func GETRequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: "GET")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(responseType: responseType, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - POST Request Methods
    
    func POSTRequest(url: URL, completion: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: "POST")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func POSTRequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: "POST")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(responseType: responseType, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func POSTRequest<Response: Decodable, Request: Encodable>(url: URL, responseType: Response.Type, body: Request, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: "POST", body: body)
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(responseType: responseType, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - PUT Request Methods
    
    func PUTRequest(url: URL, completion: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: "PUT")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func PUTRequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: "PUT")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(responseType: responseType, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func PUTRequest<Response: Decodable, Request: Encodable>(url: URL, responseType: Response.Type, body: Request, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: "PUT", body: body)
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(responseType: responseType, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - DELETE Request Methods
    
    func DELETERequest(url: URL, completion: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: "DELETE")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func DELETERequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: "DELETE")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(responseType: responseType, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func DELETERequest<Response: Decodable, Request: Encodable>(url: URL, responseType: Response.Type, body: Request, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: "DELETE", body: body)
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(responseType: responseType, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - Download Methods
    
    func downloadData(url: URL, completion: @escaping (Result<Data,NetworkError>) -> Void) -> URLSessionDataTask {
        let request = composeRequest(url: url, method: "GET")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.dataTaskHandler(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
        return task
    }
    
}

enum NetworkError: Error {

    case noResponse
    case client(Error)
    case server(HTTPError)
    
}

extension NetworkManager {
    
    // MARK: - Helper Methods
    
    private func composeRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        if let accessToken = SessionManager.standard.sessionToken {
            if accessToken != "" {
                request.addValue("Token \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        method == "PUT" ? request.addValue("zero", forHTTPHeaderField: "Content-Length") : nil
        
        return request
    }
    
    private func composeRequest<Request: Encodable>(url: URL, method: String, body: Request) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        if let accessToken = SessionManager.standard.sessionToken {
            if accessToken != "" {
                request.addValue("Token \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        return request
    }
    
    private func dataTaskHandler(response: URLResponse?, error: Error?, completion: @escaping (NetworkError?) -> Void) {
        DispatchQueue.main.async {
            if let error = error {
                completion(.client(error))
            } else if let networkError = self.processResponse(response: response) {
                completion(networkError)
            } else {
                completion(nil)
            }
        }
    }
    
    private func dataTaskHandler(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(.client(error)))
            } else if let networkError = self.processResponse(response: response) {
                completion(.failure(networkError))
            } else if let data = data {
                completion(.success(data))
            }
        }
    }
    
    private func dataTaskHandler<Response: Decodable>(responseType: Response.Type, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Response,NetworkError>) -> Void) {
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(.client(error)))
            } else if let networkError = self.processResponse(response: response) {
                completion(.failure(networkError))
            } else if let data = self.decodeData(responseType: responseType, data: data, error: error) {
                completion(.success(data))
            }
        }
    }
    
    private func processResponse(response: URLResponse?) -> NetworkError? {
        guard response != nil else {
            return .noResponse
        }
        let httpResponse = response as? HTTPURLResponse
        let httpStatusCode = httpResponse?.statusCode ?? 0
        
        if (200...299).contains(httpStatusCode) {
            return nil
        } else {
            let httpError = HTTPError.withCode(httpStatusCode)
            return .server(httpError)
        }
    }
    
    private func decodeData<Response: Decodable>(responseType: Response.Type, data: Data?, error: Error?) -> Response? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(responseType, from: data)
            return responseObject
        } catch {
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                return errorResponse as? Response
            } catch {
                return nil
            }
        }
    }
    
}
