//
//  Constants.swift
//  marvelMovie-iOS
//
//  Created by Partha Pratim on 22/11/23.
//

import Foundation

class Constants: NSObject{
    
    static let sharedInstance: Constants = {
        let instance = Constants()
        return instance
    }()
    
    
    var baseUrl: String = "https://api.themoviedb.org/3/search/movie"
    var apiKey: String = "38e61227f85671163c275f9bd95a8803"
    var imageBaseUrl: String = "https://image.tmdb.org/t/p/original"
}
