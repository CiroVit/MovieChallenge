//
//  MovieView.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 24/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import Foundation

class MovieViewModel {
    private var service = TMDBService()
    private var Movies = [Movie]()
    
    func fetchMoviesData(completion : @escaping () -> ()) {
        service.getMoviesData { [weak self] (Result) in
            
            switch Result {
            case .success(let listOf) :
                self?.Movies = listOf.movies
                completion()
            case .failure(let error):
                print("error Processino Json")
            }
        }
    }
    func numberOfRowInSection(section: Int) -> Int {
        if Movies.count != 0 {
            return Movies.count
        }
        return 0
        
    }
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return Movies[indexPath.row]
    }
}
