//
//  NetworkManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let urlSession: URLSession!
    
    // MARK: - Initialisation
    
    private init() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        urlSession = URLSession(configuration: urlSessionConfiguration)
    }
    
    // MARK: - GET Request Methods
    
    func GETRequest(url: URL, completion: @escaping (Error?) -> Void) {
        let request = composeRequest(url: url, method: "GET")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
        }
        task.resume()
    }
    
    func GETRequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Response?, Error?) -> Void) {
        let request = composeRequest(url: url, method: "GET")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
            self.processData(data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - POST Request Methods
    
    func POSTRequest(url: URL, completion: @escaping (Error?) -> Void) {
        let request = composeRequest(url: url, method: "POST")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
        }
        task.resume()
    }
    
    func POSTRequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Response?, Error?) -> Void) {
        let request = composeRequest(url: url, method: "POST")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
            self.processData(data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    func POSTRequest<Response: Decodable, Request: Encodable>(url: URL, responseType: Response.Type, body: Request, completion: @escaping (Response?, Error?) -> Void) {
        let request = composeRequest(url: url, method: "POST", body: body)
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
            self.processData(data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - PUT Request Methods
    
    func PUTRequest(url: URL, completion: @escaping (Error?) -> Void) {
        let request = composeRequest(url: url, method: "PUT")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
        }
        task.resume()
    }
    
    func PUTRequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Response?, Error?) -> Void) {
        let request = composeRequest(url: url, method: "PUT")
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
            self.processData(data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    func PUTRequest<Response: Decodable, Request: Encodable>(url: URL, responseType: Response.Type, body: Request, completion: @escaping (Response?, Error?) -> Void) {
        let request = composeRequest(url: url, method: "PUT", body: body)
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
            self.processData(data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - DELETE Request Methods
    
    func DELETERequest(url: URL, completion: @escaping (Error?) -> Void) {
        let request = composeRequest(url: url, method: "DELETE")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
        }
        task.resume()
    }
    
    func DELETERequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Response?, Error?) -> Void) {
        let request = composeRequest(url: url, method: "DELETE")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
            self.processData(data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    func DELETERequest<Response: Decodable, Request: Encodable>(url: URL, responseType: Response.Type, body: Request, completion: @escaping (Response?, Error?) -> Void) {
        let request = composeRequest(url: url, method: "DELETE", body: body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.processResponse(response: response!, completion: completion)
            self.processData(data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    func downloadData(url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let accessToken = SessionManager.standard.sessionToken {
            if accessToken != "" {
                request.addValue("Token \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
        return task
    }
    
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
    
    private func processResponse(response: URLResponse, completion: @escaping (Error?) -> Void) {
        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            if httpResponse.statusCode == 204 {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
        } else {
            let httpError = HTTPError.withCode((response as? HTTPURLResponse)!.statusCode)
            DispatchQueue.main.async {
                completion(httpError)
            }
            return
        }
    }
    
    private func processResponse<Response: Decodable>(response: URLResponse, completion: @escaping (Response?, Error?) -> Void) {
        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            if httpResponse.statusCode == 204 {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
        } else {
            let httpError = HTTPError.withCode((response as? HTTPURLResponse)!.statusCode)
            DispatchQueue.main.async {
                completion(nil, httpError)
            }
            return
        }
    }
    
    private func processData<Response: Decodable>(data: Data?, error: Error?, completion: @escaping (Response?, Error?) -> Void) {
        guard let data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(Response.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        } catch {
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                DispatchQueue.main.async {
                    completion(nil, errorResponse)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
}
