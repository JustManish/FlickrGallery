//
//  NetworkService.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import Foundation
import UIKit

enum ImageLoadingError: Error {
    case networkFailure(Error)
    case invalidData
    case NetworkUnavailable
}

class NetworkService {
    
    
    static let shared = {
        return NetworkService()
    }()
    
    func request(_ request: HttpRequest, completion: @escaping (Result<Data,Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request as URLRequest) { result in
            switch result{
            
            case .success(let data) :
                completion(.success(data))
                
            case .failure(let error) :
                completion(.failure(error))
           }
        }.resume()
    }
        
        
        
    
    func downloadImageFrom(_ urlString: String, completion: @escaping (Result<UIImage,ImageLoadingError>) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        guard let url =  URL(string: urlString) else {
            return completion(.failure(.invalidData))
        }
        
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return completion(.failure(.NetworkUnavailable))
        }
        
        session.downloadTask(with: url) { (url, reponse, error) in
            do {
                guard let url = url else {
                    return completion(.failure(.invalidData))
                }
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    return completion(.success(image))
                } else {
                    return completion(.failure(.networkFailure(error!)))
                }
            } catch {
                return completion(.failure(.networkFailure(error)))
            }
        }.resume()
        
    }
    
}
