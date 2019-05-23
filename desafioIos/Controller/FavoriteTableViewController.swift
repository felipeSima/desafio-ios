//
//  FavoriteTableViewController.swift
//  desafioIos
//
//  Created by Felipe Silva Lima on 5/13/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage
import SwipeCellKit

class FavoriteTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var movieInfo: Results<Favorites>?
    let baseUrl: String = "https://image.tmdb.org/t/p"
    let fileSize: String = "/w500"
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        myTableView.reloadData()
        configureTableViewCell()
        myTableView.register(UINib(nibName: "CustomTableCellTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadInfo()
        myTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieInfo?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableCellTableViewCell
        
        cell.delegate = self
        
        if let info = movieInfo?[indexPath.row] {
            var url = baseUrl + fileSize + info.realmPoster
            Alamofire.request(url).responseImage { response in
                if let poster = response.result.value {
                    cell.setTableCell(image: poster, title: info.realmTitle, date: info.realmDate, description: info.realmDescription)
                }
            }
        }
        else {
            cell.setTableCell(image: UIImage (named: "emptyPoster")!, title: "Your Next Favorite Movie", date: "Save the Date", description: "The Description of one of the greatest movies that you will watch")
        }
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        performSegue(withIdentifier: "cellToDetails", sender: indexPath)
    //    }
    
    func loadInfo() {
        movieInfo = realm.objects(Favorites.self)
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
    
    func configureTableViewCell() {
        
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = 200
        
    }
}

extension FavoriteTableViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Unfavorite") { action, indexPath in
            self.deleteFavorite(sender: indexPath)
            self.loadInfo()
            self.myTableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}

//MARK: - Search Bar Methods
extension FavoriteTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "realmTitle CONTAINS[cd] %@", searchBar.text!)
        let date = NSPredicate(format: "realmDate CONTAINS[cd] %@", searchBar.text!)
        movieInfo = movieInfo?.filter(predicate).sorted(byKeyPath: "realmTitle", ascending: true)
        tableView.reloadData()
        resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadInfo()
            tableView.reloadData()
            
        } else {
            let predicate = NSPredicate(format: "realmTitle CONTAINS[cd] %@", searchBar.text!)
            let date = NSPredicate(format: "realmDate CONTAINS[cd] %@", searchBar.text!)
            movieInfo = movieInfo?.filter(predicate).sorted(byKeyPath: "realmTitle", ascending: true)
            tableView.reloadData()
        }
    }
}
