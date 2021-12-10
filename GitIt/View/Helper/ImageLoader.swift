//
//  ImageLoader.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import Foundation
import UIKit

class ImageLoader {
    
    static let standard = ImageLoader()
    
    private var cache: NSCache<NSURL, UIImage>!
    private var runningRequests: [UUID: URLSessionDataTask]
    
    private init() {
        cache = NSCache()
        cache.countLimit = 70
        runningRequests = [UUID: URLSessionDataTask]()
    }
    
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if let image = cache.object(forKey: url as NSURL) {
            completion(.success(image))
            return nil
        }
        
        let taskUUID = UUID()
        
        let task = GithubClient.standard.downloadAvatar(url: url) { data, error in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSURL)
                completion(.success(image))
                return
            }
            guard let error = error else {
                return
            }
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        
        runningRequests[taskUUID] = task
        
        return taskUUID
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
}
