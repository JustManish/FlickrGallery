//
//  HttpRequest.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import Foundation



enum HttpMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    
    var value: String {
        return self.rawValue
    }
}

class HttpRequest: NSMutableURLRequest {
    
    convenience init?(httpMethod: HttpMethod, urlString: String, bodyParams: [String: Any]? = nil) {
        
        guard let url =  URL(string: urlString) else {
            return nil
        }
        
        self.init(url: url)
        
        do {
            if let bodyParams = bodyParams {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                self.httpBody = data
            }
        } catch {
            
        }
        
        self.httpMethod = httpMethod.value
        
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

