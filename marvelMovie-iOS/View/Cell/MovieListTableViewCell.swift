//
//  MovieListTableViewCell.swift
//  marvelMovie-iOS
//
//  Created by Partha Pratim on 22/11/23.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
