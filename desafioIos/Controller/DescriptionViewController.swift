//
//  DescriptionViewController.swift
//  desafioIos
//
//  Created by Felipe Silva Lima on 5/13/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class DescriptionViewController: UIViewController {
    
    var bankMovies = [Movies]()
    var filterMovies = [Movies]()
    
    let baseUrl: String = "https://image.tmdb.org/t/p"
    let fileSize: String = "/w500"
    
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var buttonToggle: Bool = false
    var movieTitle: String = ""
    var date: String = ""
    var genre: String = ""
    var poster: UIImage? = nil
    var movieDescription: String = ""
    var posterUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.underlined()
        
        dateTextField.underlined()
        
        genreTextField.underlined()
        
        movieInfo()

    }
    
    func movieInfo(){
        titleTextField.text = movieTitle
        dateTextField.text = date
        descriptionView.text = movieDescription
        genreTextField.text = genre
        posterRequest(url: baseUrl+fileSize+posterUrl)
    }
    
    func posterRequest(url: String){
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                self.moviePoster.image = image
            }
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        if buttonToggle == false {
            favoriteButton.setImage(UIImage(named: "favorite_gray_icon"), for: .normal)
            buttonToggle = true
        }
        else {
            favoriteButton.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
            buttonToggle = false
        }
        
    }
}

extension UITextField {
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
    }
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
