//
//  MovieListCollectDataSync.swift
//  marvelMovie-iOS
//
//  Created by Partha Pratim on 22/11/23.
//

import Foundation
import UIKit

class MovieListCollectDataSync: NSObject{
    
    var movieListDataModel: MovieListDataModel?
    var movieList: [MovieList]? = [MovieList]()

    
    var is_running : Bool = false
    var currentPage : Int = 1
    
    static let sharedInstance: MovieListCollectDataSync = {
        let instance = MovieListCollectDataSync()
        return instance
    }()
    
    override init() {
        super.init()
        is_running = false
    }
    
    func fetchData() {
        
        let parameters: [String: Any] = [
            "api_key": appDelegate.constants.apiKey,
            "page": currentPage,
            "query": "marvel",
        ]
        var urlComponents = URLComponents(string: appDelegate.constants.baseUrl)!
        urlComponents.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                LoadingIndicatorView.hide()
                return
            }
            
            if let data = data {
                do {
                    print(self.currentPage)
                    let decoder = JSONDecoder()
                    print(data)
                    let dataModel = try decoder.decode(MovieListDataModel?.self, from: data)
                    self.movieListDataModel = dataModel
                    self.movieList?.append(contentsOf: (self.movieListDataModel?.results)!)
                    self.currentPage = (self.movieListDataModel?.page)!
                    print(self.currentPage)
                    DispatchQueue.main.async(execute: {
                        if let topController = appDelegate.movieListViewController {
                            if (topController.isKind(of: MovieListViewController.self)){
                                (topController).reloadData()
                                return
                            }
                        }
                    })
                } catch {
                    DispatchQueue.main.async(execute: {
                        if let topController = appDelegate.movieListViewController {
                            if (topController.isKind(of: MovieListViewController.self)){
                                (topController).reloadData()
                                return
                            }
                        }
                    })
                }
            }
        }
        task.resume()
        
    }
}
