//
//  Model.swift
//  MoovieCard
//
//  Created by a on 19.09.2020.
//  Copyright © 2020 a. All rights reserved.
//

import Foundation

struct Moovie: Decodable {
    var results: [Results]
}

struct Results: Decodable {
    
    var isFavouriteMovie: Bool = false
    let title: String?
    let vote_average: Double?
    let overview: String?
    let release_date: String?
    let poster_path: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case vote_average
        case overview
        case release_date
        case poster_path
    }
}
