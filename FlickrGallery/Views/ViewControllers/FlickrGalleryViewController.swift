//
//  ViewController.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import UIKit

class FlickrGalleryViewController: UIViewController {

    @IBOutlet weak var flickrCollectionView: UICollectionView!
    
    private var searchBarController: UISearchController!
    
    private var viewModel = FlickrViewModel()
    
    private var gridCount = CGFloat(2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    private func createSearchBar() {
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
    }
    
    fileprivate func configureUI() {
        // Do any additional setup after loading the view, typically from a nib.
        createSearchBar()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        flickrCollectionView.delegate = self
        flickrCollectionView.dataSource = self
        viewModel.eventNotifierDelegate = self
    }


}

extension FlickrGalleryViewController : EventNotifierDelegate{
    func showAlertMessage(message: String) {
        self.showAlert(message: message)
    }
    
    func notifyUpdate() {
        print("data updated")
        self.flickrCollectionView.reloadData()
    }
}

//Mark :- UISearchController Delegate
extension FlickrGalleryViewController : UISearchControllerDelegate, UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        
        flickrCollectionView.reloadData()
        
        viewModel.search(text: text) {
            print("search completed.")
        }
        
        searchBarController.searchBar.resignFirstResponder()
    }
}


//Mark :- UICollectionViewDataSource
extension FlickrGalleryViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.id, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        
        let data = viewModel.photoArray[indexPath.row]
        cell.data = FlickrData(withPhotos: data)
        
        if indexPath.row == (viewModel.photoArray.count - 10) {
            loadNext()
        }
    }
    
    
    private func loadNext() {
        viewModel.fetchNextPage {
            print("next page loaded")
        }
    }
    
    
}

//MARK:- UICollectionViewDelegateFlowLayout
extension FlickrGalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/gridCount, height: (collectionView.bounds.width)/gridCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


//Mark :- UICollectionViewDelegate
extension FlickrGalleryViewController : UICollectionViewDelegate{
    
    
    
}


