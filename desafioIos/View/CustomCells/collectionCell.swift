//
//  collectionCell.swift
//  desafioIos
//
//  Created by Felipe Silva Lima on 5/12/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import RealmSwift


class collectionCell: UICollectionViewCell {

    var link: MovieViewController?
    
    var dbLink: FavoriteTableViewController?
    
    let realm = try! Realm()
    
    let favorites = Favorites()
    
    var movieInfo: Results<Favorites>?
    
    @IBOutlet weak var movieView: UIImageView!
    
    @IBOutlet weak var moviesLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var buttonToggle: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCollectionCell(image: UIImage, text: String){
        
        moviesLabel.numberOfLines = 2
        moviesLabel.adjustsFontSizeToFitWidth = true
        self.movieView.image = image
        self.moviesLabel.text = text
    }
    
    func favoriteSave() {
        do{
            try realm.write {
                realm.add(favorites)
            }
        }catch {
            print("Error initializing new realm: \(error)")
        }
    }
    
    func favoriteDelete() {
        do{
            try realm.write {
                realm.delete(favorites)
            }
        }catch {
            print("Error initializing new realm: \(error)")
        }
    }
    
    func favoriteInfo() {
        
        if let movieInfo = link?.movieInfo(cell: self) {
            favorites.realmTitle = movieInfo.title
            favorites.realmDate = movieInfo.releaseDate
            favorites.realmDescription = movieInfo.overview
            favorites.realmPoster = movieInfo.posterPath
        }
    }
    
    func deleteFavorite(sender: Any){
        let indexPath = sender as! IndexPath
        do{
            let realm = try Realm()
            try realm.write {
                realm.delete(movieInfo![indexPath.row])
            }
        }catch {
            print("Error initializing new realm: \(error)")
        }
    }

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        if buttonToggle == false {
            favoriteInfo()
            favoriteSave()
            favoriteButton.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
            buttonToggle = true
            print("CLICOU")
        } else {
            favoriteButton.setImage(UIImage(named: "favorite_gray_icon"), for: .normal)
            buttonToggle = false
//            print(dbLink?.movieInfo?.count)
//            if let movieInfo = dbLink?.movieInfo {
//                print("COUNT: \(movieInfo.count)")
//                for index in 0..<movieInfo.count {
//                    if favorites.realmTitle == movieInfo[index].realmTitle{
//                        dbLink?.deleteFavorite(sender: index)
//                        dbLink?.tableView.reloadData()
//                    }
//                }
//            }
        }
    }
}

