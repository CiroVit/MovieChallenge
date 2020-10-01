//
//  SearchViewController.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 29/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    
    let movieService = TMDBService()
    let searchViewModel = MovieViewModel()
    let movie : Movie? = nil
    let searchBar = UISearchBar()
    
    var SearchingTitleToSend = [UILabel]()
    var SearchingposterToSend = [UIImageView]()
    var SearchingdescriptionToSend = [UILabel]()
    var SearchingrateToSend = [UILabel]()
    var SearchingyearToSend = [UILabel]()

    
    fileprivate let searchCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv1 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv1.translatesAutoresizingMaskIntoConstraints = false
        cv1.register(TVCell.self, forCellWithReuseIdentifier: "searchCell")
        return cv1
    }()
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
       
        
        Visual()

      
    }
    
    
    
    
    func Visual() {
        view.addSubview(searchBar)
        view.addSubview(searchCollectionView)
        searchCollectionView.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
        searchCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40).isActive = true
        searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchCollectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        searchCollectionView.delegate = self
        searchCollectionView.showsHorizontalScrollIndicator = false
        
        searchBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: 100, left: 10, bottom: 0, right: 10))
                
                searchBar.sizeToFit()
    }


}

extension SearchViewController: UISearchResultsUpdating {
 
    func updateSearchResults(for searchController: UISearchController) {
        movies = []
 
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        
        movieService.searchMovie(query: text, params: nil, successHandler: {[unowned self] (response) in
            
            if searchController.searchBar.text == text {
                self.movies = response.movies
            }
        }) { [unowned self] (error) in
           error
        }
        
    }
    
}
extension SearchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    MARK - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize( width: collectionView.frame.width/2.5, height: collectionView.frame.width/2.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = ShowDetailsViewController()
        detailController.DetailsTitle = SearchingTitleToSend [indexPath.row]
        detailController.DetailsYear = SearchingyearToSend [indexPath.row]
        detailController.DetailsRate = SearchingrateToSend [indexPath.row]
        detailController.DetailsPoster = SearchingposterToSend [indexPath.row]
        detailController.DetailsDescription = SearchingdescriptionToSend [indexPath.row]
            present(detailController, animated: false, completion: nil)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searchViewModel.numberOfRowInSection(section: section)
       
    }
    
    func collectionView(_ collectionView : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! TVCell
        let movie = searchViewModel.cellForRowAt(indexPath: indexPath)
        cell.settings(movie)
        let title = cell.MTitle
        let poster = cell.MPoster
        let rate = cell.MRate
        let year = cell.MYear
        let description = cell.MDescription
        SearchingTitleToSend.append(title)
        SearchingposterToSend.append(poster)
        SearchingrateToSend.append(rate)
        SearchingyearToSend.append(year)
        SearchingdescriptionToSend.append(description)
        return cell
        }
}


