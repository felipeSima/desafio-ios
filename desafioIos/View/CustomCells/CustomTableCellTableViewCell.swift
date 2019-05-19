//
//  CustomTableCellTableViewCell.swift
//  desafioIos
//
//  Created by Felipe Silva Lima on 5/15/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomTableCellTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDate: UILabel!
    
    @IBOutlet weak var movieOverview: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieTitle.numberOfLines = 2
        movieTitle.adjustsFontSizeToFitWidth = true
        movieDate.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

    func setTableCell(image: UIImage, title: String, date: String, description: String){
        movieTitle.text = title
        moviePoster.image = image
        movieDate.text = date
        movieOverview.text = description
    }
    
}
