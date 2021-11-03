//
//  FlickrViewModel.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import Foundation

import UIKit


protocol EventNotifierDelegate {
    
    func showAlertMessage(message : String) -> (Void)
    func notifyUpdate() -> (Void)
}

class FlickrViewModel {
    
    private(set) var photoArray = [Photo]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
    var eventNotifierDelegate : EventNotifierDelegate?
    
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        guard let request = FlickrRequestConfig.searchRequest(searchText, pageNo).value else {
            return
        }
        
        NetworkService.shared.request(request) { (result) in
            switch result {
            case .Success(let responseData):
                if let model = self.processResponse(responseData) {
                    if let stat = model.stat, stat.uppercased().contains("OK") {
                        return completion(.Success(model.photos))
                    } else {
                        return completion(.Failure(NetworkService.errorMessage))
                    }
                } else {
                    return completion(.Failure(NetworkService.errorMessage))
                }
            case .Failure(let message):
                return completion(.Failure(message))
            case .Error(let error):
                return completion(.Failure(error))
            }
        }
    }
    
    func processResponse(_ data: Data) -> FlickrResponse? {
        do {
            let responseModel = try JSONDecoder().decode(FlickrResponse.self, from: data)
            return responseModel
            
        } catch {
            print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    
    func search(text: String, completion:@escaping () -> Void) {
        searchText = text
        photoArray.removeAll()
        fetchResults(completion: completion)
    }
    
    private func fetchResults(completion:@escaping () -> Void) {
        
        request(searchText, pageNo: pageNo) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .Success(let results):
                    if let result = results {
                        self.totalPageNo = result.pages
                        self.photoArray.append(contentsOf: result.photo)
                        self.eventNotifierDelegate?.notifyUpdate()
                    }
                    completion()
                case .Failure(let message):
                    self.eventNotifierDelegate?.showAlertMessage(message: message)
                    completion()
                case .Error(let error):
                    if self.pageNo > 1 {
                        self.eventNotifierDelegate?.showAlertMessage(message: error)
                    }
                    completion()
                }
            }
        }
    }
    
    func fetchNextPage(completion:@escaping () -> Void) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResults {
                completion()
            }
        } else {
            completion()
        }
    }
}
