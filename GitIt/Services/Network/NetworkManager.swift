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
    
    func GETRequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: .GET)
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func GETRequest<Response: Decodable>(url: URL, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: .GET)
        urlSession.dataTask(with: request) { dataResult in
            completionHandler(self.decodeDataResult(dataResult))
        }.resume()
    }
    
    // MARK: - POST Request Methods
    
    func POSTRequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: .POST)
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func POSTRequest<Response: Decodable>(url: URL, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: .POST)
        urlSession.dataTask(with: request) { dataResult in
            completionHandler(self.decodeDataResult(dataResult))
        }.resume()
    }
    
    func POSTRequest<Response: Decodable, Request: Encodable>(url: URL, body: Request, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) {
        if let request = composeRequest(url: url, method: .POST, body: body, completionHandler: completionHandler) {
            urlSession.dataTask(with: request) { dataResult in
                completionHandler(self.decodeDataResult(dataResult))
            }.resume()
        }
    }
    
    // MARK: - PUT Request Methods
    
    func PUTRequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: .PUT)
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func PUTRequest<Response: Decodable>(url: URL, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: .PUT)
        urlSession.dataTask(with: request) { dataResult in
            completionHandler(self.decodeDataResult(dataResult))
        }.resume()
    }
    
    func PUTRequest<Response: Decodable, Request: Encodable>(url: URL, body: Request, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) {
        if let request = composeRequest(url: url, method: .PUT, body: body, completionHandler: completionHandler) {
            urlSession.dataTask(with: request) { dataResult in
                completionHandler(self.decodeDataResult(dataResult))
            }.resume()
        }
    }
    
    // MARK: - DELETE Request Methods
    
    func DELETERequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) {
        let request = composeRequest(url: url, method: .DELETE)
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func DELETERequest<Response: Decodable>(url: URL, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) {
        let request = composeRequest(url: url, method: .DELETE)
        urlSession.dataTask(with: request) { dataResult in
            completionHandler(self.decodeDataResult(dataResult))
        }.resume()
    }
    
    func DELETERequest<Response: Decodable, Request: Encodable>(url: URL, body: Request, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) {
        if let request = composeRequest(url: url, method: .DELETE, body: body, completionHandler: completionHandler) {
            urlSession.dataTask(with: request) { dataResult in
                completionHandler(self.decodeDataResult(dataResult))
            }.resume()
        }
    }
    
    // MARK: - Download Methods
    
    func downloadData(url: URL, completionHandler: @escaping (DataResult) -> Void) -> URLSessionDataTask {
        let request = composeRequest(url: url, method: .GET)
        let task = urlSession.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        return task
    }

}

extension NetworkManager {
    
    // MARK: - Helper Methods
    
    private func composeRequest(url: URL, method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        if let accessToken = SessionManager.standard.sessionToken {
            if accessToken != "" {
                request.addValue("Token \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        method == .PUT ? request.addValue("zero", forHTTPHeaderField: "Content-Length") : nil
        
        return request
    }
    
    private func composeRequest<Request: Encodable>(url: URL, method: HTTPMethod, body: Request, completionHandler: @escaping (NetworkError?) -> Void) -> URLRequest? {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        if let accessToken = SessionManager.standard.sessionToken {
            if accessToken != "" {
                request.addValue("Token \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completionHandler(.encoding(error))
            return nil
        }
        
        return request
    }
    
    private func composeRequest<Response: Decodable, Request: Encodable>(url: URL, method: HTTPMethod, body: Request, completionHandler: @escaping (Result<Response,NetworkError>) -> Void) -> URLRequest? {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        if let accessToken = SessionManager.standard.sessionToken {
            if accessToken != "" {
                request.addValue("Token \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completionHandler(.failure(.encoding(error)))
            return nil
        }
        
        return request
    }
    
    private func decodeDataResult<Response: Decodable>(_ dataResult: DataResult) -> Result<Response,NetworkError> {
        return dataResult.flatMap { (data) -> Result<Response,NetworkError> in
            do {
                let responseObject = try JSONDecoder().decode(Response.self, from: data)
                return .success(responseObject)
            } catch {
                do {
                    let errorObject = try JSONDecoder().decode(APIError.self, from: data)
                    return .failure(.api(errorObject))
                } catch { return .failure(.decoding(error)) }
            }
        }
    }
    
}
