//
//  Constants.swift
//  marvelMovie-iOS
//
//  Created by Partha Pratim on 22/11/23.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieListTableView: UITableView!
    @IBOutlet weak var emptyListLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    
    var movieList: [MovieList]? = [MovieList]()
    var totalMovieList: [MovieList]? = [MovieList]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieListTableView.alpha = 0
        LoadingIndicatorView.show()
        appDelegate.movieListCollectDataSync.movieList?.removeAll()
        self.movieList?.removeAll()
        self.movieListTableView.refreshControl = UIRefreshControl()
        self.movieListTableView.refreshControl?.addTarget(self, action: #selector(self.dataSyncFromApi), for: .valueChanged)
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        appDelegate.movieListCollectDataSync.fetchData()
    }
    
    @objc func dataSyncFromApi(){
        appDelegate.movieListCollectDataSync.currentPage = 1
        appDelegate.movieListCollectDataSync.movieList?.removeAll()
        self.movieListTableView.refreshControl?.endRefreshing()
        appDelegate.movieListCollectDataSync.fetchData()
    }
    
    func reloadData() {
        self.movieList?.removeAll()
        self.totalMovieList?.removeAll()
        self.totalMovieList = appDelegate.movieListCollectDataSync.movieList
        if (self.totalMovieList?.count)! > 0 {
            
            if(txtSearch.text != ""){
                for index in 0..<totalMovieList!.count{
                    if(totalMovieList![index].title!.lowercased().contains(txtSearch.text!.lowercased())){
                        movieList?.append(totalMovieList![index])
                    }
                }
            }else{
                self.movieList = appDelegate.movieListCollectDataSync.movieList
            }
            DispatchQueue.main.async(execute: {
                LoadingIndicatorView.hide()
                self.movieListTableView.alpha = 1
                self.movieListTableView.reloadData()
                appDelegate.movieListCollectDataSync.is_running = false
            })
            
        } else{
            DispatchQueue.main.async(execute: {
                LoadingIndicatorView.hide()
                self.movieListTableView.alpha = 0
                self.emptyListLbl.alpha = 1
                appDelegate.movieListCollectDataSync.is_running = false
            })
        }
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        txtSearch?.resignFirstResponder()
        LoadingIndicatorView.show()
        self.reloadData()
    }
    
    @objc func textFieldDidChange(_ txtSearch: UITextField) {
        if txtSearch.text == "" {
            LoadingIndicatorView.show()
            self.reloadData()
        }else{
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = movieList?[indexPath.row].overview
        let textFont = UIFont.systemFont(ofSize: 17.0)
        let textAttributes = [NSAttributedString.Key.font: textFont]
        let textBoundingSize = CGSize(width: tableView.frame.width - 16, height: .greatestFiniteMagnitude)
        let textRect = (text! as NSString).boundingRect(with: textBoundingSize,
                                                               options: .usesLineFragmentOrigin,
                                                               attributes: textAttributes,
                                                               context: nil)
        let cellHeight = textRect.height + 20
        return cellHeight > 120 ? cellHeight : 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListTableViewCell = movieListTableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell", for: indexPath as IndexPath) as! MovieListTableViewCell
        cell.movieDescription?.numberOfLines = 0
        cell.movieTitle.text = movieList?[indexPath.row].title
        cell.movieDescription.text = movieList?[indexPath.row].overview
        let info = movieList?[indexPath.row].posterPath
        if let imageUrl = URL(string: "\(appDelegate.constants.imageBaseUrl)\(info ?? "")") {
                    let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                        if error != nil {
                            return
                        }
                        guard let data = data else {
                            return
                        }
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.movieImage.image = image
                            }
                        }
                    }
                    task.resume()
                }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = movieListTableView.visibleCells
        if let firstCell = visibleCells.last {
            if let indexPath = movieListTableView.indexPath(for: firstCell){
                if(appDelegate.movieListCollectDataSync.is_running){
                    return
                }else{
                    if (indexPath.row >= (movieList!.count - 2)){
                        DispatchQueue.main.async(execute: {
                            appDelegate.movieListCollectDataSync.is_running = true
                            LoadingIndicatorView.show()
                            appDelegate.movieListCollectDataSync.currentPage = appDelegate.movieListCollectDataSync.currentPage + 1
                            appDelegate.movieListCollectDataSync.fetchData()})
                    }
                }
            }
        }
    }

}
