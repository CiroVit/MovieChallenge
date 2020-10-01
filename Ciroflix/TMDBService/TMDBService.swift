//
//  TMDBService.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 24/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import Foundation

class TMDBService {
    
    private enum endpoint : String {
        case nowPlaying = "now_playing"
        case upcoming = "upcoming"
        case toprated = "top_rater"
        case popular = "popular"
        
        var rawValue: String {
                switch self {
                case .nowPlaying: return "now_playing"
                case .upcoming: return "upcoming"
                case .toprated: return "top_rater"
                case .popular: return "popular"
                }
      }
    }
    private var dataTask : URLSessionTask?
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let apiKey = "0d3187a66a74f922c4bb786b8ed2dd53"
    private let urlSession = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
           let jsonDecoder = JSONDecoder()
           jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
//    movie api url
    func getMoviesData(completion : @escaping (Result<MoviesData, Error>) -> Void) {
   let MoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=0d3187a66a74f922c4bb786b8ed2dd53&language=en-US"
        
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
    func getNowPlayingMoviesData(completion : @escaping (Result<MoviesData, Error>) -> Void) {
   let MoviesURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=0d3187a66a74f922c4bb786b8ed2dd53&language=en-US&page=1"
        
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
    
    
    func getMoviesUpcomingData(completion : @escaping (Result<MoviesData, Error>) -> Void) {
   let LatestMoviesURL =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=0d3187a66a74f922c4bb786b8ed2dd53&language=en-US&page=1"
        
        guard let url = URL(string: LatestMoviesURL) else {return}
        
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
    
    func searchMovie(query: String, params: [String : String]?, successHandler: @escaping (_ response : MoviesData) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
            
        guard var urlComponents = URLComponents(string: "\(baseAPIURL)/movie/\(endpoint.RawValue())") else {
            errorHandler(Error.self as! Error)
                    return
                }
                
                var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
                if let params = params {
                    queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
                }
                urlComponents.queryItems = queryItems
                
                guard let url = urlComponents.url else {
                    errorHandler(Error.self as! Error)
                    return
                }
                
                urlSession.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.handleError(errorHandler: errorHandler, error: Error.self as! Error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        self.handleError(errorHandler: errorHandler, error:  Error.self as! Error)
                        return
                    }
                    
                    guard let data = data else {
                        self.handleError(errorHandler: errorHandler, error:  Error.self as! Error)
                        return
                    }
                    
                    do {
                        let moviesResponse = try self.jsonDecoder.decode(MoviesData.self, from: data)
                        DispatchQueue.main.async {
                            successHandler(moviesResponse)
                        }
                    } catch {
                        self.handleError(errorHandler: errorHandler, error: Error.self as! Error)
                    }
                }.resume()
                
            }
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
           DispatchQueue.main.async {
               errorHandler(error)
           }
       }
       
}
