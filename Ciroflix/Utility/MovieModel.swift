//
//  MovieModel.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 24/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import Foundation
import RealmSwift

struct MoviesData: Decodable {
    let movies : [Movie]

     private enum CodingKeys: String, CodingKey {
         case movies = "results"
     }
 }

 struct Movie: Decodable{

     let title: String?
     let year: String?
     let rate: Double?
     let posterImage: String?
     let overview: String?

     private enum CodingKeys: String, CodingKey {
         case title, overview
         case year = "release_date"
         case rate = "vote_average"
         case posterImage = "poster_path"
     }
 }

