//
//  URLSession+Extension.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 05/11/21.
//

import Foundation

extension URLSession {
    func dataTask(
        with request: URLRequest,
        handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}
