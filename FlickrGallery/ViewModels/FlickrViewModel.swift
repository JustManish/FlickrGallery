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
    
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?, Error>) -> Void) {
        
        guard let request = FlickrRequestConfig.searchRequest(searchText, pageNo).value else {
            return
        }
        
        NetworkService.shared.request(request) { result in
            switch result{
            
            case .success(let data) :
                if let model = self.processResponse(data) {
                    if let stat = model.stat, stat.uppercased().contains("OK") {
                        return completion(.success(model.photos))
                    }
                }
                
            case .failure(let error) :
                return completion(.failure(error))
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
                case .success(let results):
                    if let result = results {
                        self.totalPageNo = result.pages
                        self.photoArray.append(contentsOf: result.photo)
                        self.eventNotifierDelegate?.notifyUpdate()
                    }
                    completion()
                case .failure(let error):
                    self.eventNotifierDelegate?.showAlertMessage(message: error.localizedDescription)
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
