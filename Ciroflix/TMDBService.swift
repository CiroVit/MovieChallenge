//
//  TMDBService.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 24/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import Foundation

class TMDBService {
    private var dataTask : URLSessionTask?
//    movie api url
    func getMoviesData(completion : @escaping (Result<MoviesData, Error>) -> Void) {
   let MoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=0d3187a66a74f922c4bb786b8ed2dd53&language=en-US&page=1"
        
        guard let url = URL(string: MoviesURL) else {return}
        
//        session
        dataTask = URLSession.shared.dataTask(with: url) { (data,response,error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error\(error.localizedDescription)")
                return
        }
            
            guard let response = response as? HTTPURLResponse else {
                print("empty")
                return
            }
            print("respose status code : \(response.statusCode)")
            guard let data = data else {
                print("empty")
                return
            }
            
            do {
//                parse
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }   catch let error {
                    completion(.failure(error))
                }
                
            }
            dataTask?.resume()
        }
        
    }

