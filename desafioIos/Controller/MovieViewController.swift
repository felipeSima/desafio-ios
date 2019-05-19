//
//  MovieViewController.swift
//  desafioIos
//
//  Created by Felipe Silva Lima on 5/12/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD



class MovieViewController: UIViewController {
    
    //MARK: - Properties, Constants
    
    var bankMovies = [Movies]()
    var searchMovies = [Movies]()
    var genre = [Genres]()
    
    
    var searching = false
    var pageCount = 1
    var isDataLoading = false
    
    private let reuseIdentifier = "collectionCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 15.0,
                                             bottom: 10.0,
                                             right: 15.0)
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let apiKey: String = "2c9f1fce7d092177515db21991f8cfd1"
    let baseUrl: String = "https://api.themoviedb.org/3/discover/movie?api_key="
    let endPoint: String = "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="
    var page: String = "1"
    
    let baseImageUrl: String = "https://image.tmdb.org/t/p"
    let fileSize: String = "/w500"
    var posterPath: String = ""
    var imageUrl: String = ""
    
    
    //Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializing Networking Service
        startRequest(url: baseUrl+apiKey+endPoint+page)
        
        
        //Setting the Delegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //Register Cells
        self.collectionView!.register(UINib(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.reloadData()
        
    }
    
    func movieInfo(cell: UICollectionViewCell) -> Movies{
        let movieInfo = Movies()
        if let indexPath = collectionView.indexPath(for: cell){
            movieInfo.title = (bankMovies[(indexPath.row)].title)
            movieInfo.releaseDate = (bankMovies[(indexPath.row)].releaseDate)
            movieInfo.overview = (bankMovies[(indexPath.row)].overview)
            movieInfo.posterPath = (bankMovies[(indexPath.row)].posterPath)
        }
        return movieInfo
    }
    
    //MARK: - Networking Service Request
    
    func startRequest(url: String){
        let genreUrl: String = "https://api.themoviedb.org/3/genre/movie/list?api_key=2c9f1fce7d092177515db21991f8cfd1&language=en-US"
        
        Alamofire.request(url, method: .get).responseString { (response) in
            if response.result.isSuccess {
                
                //Encoding Result valeu of type string for use as JSON
                let encodedString = Data(response.result.value!.utf8)
                do {
                    //Decoding the Result as a JSON for easy use, as said in the documentation of Swift 4.1
                    let finalJSON = try JSON(data: encodedString)
                    self.jsonParsing(with: finalJSON)
                } catch {return}
            }
            else {
                print("Error attempting to get data \(String(describing: response.result.error))")
            }
        }
        Alamofire.request(genreUrl, method: .get).responseString { (response) in
            if response.result.isSuccess {
                
                //Encoding Result valeu of type string for use as JSON
                let encodedString = Data(response.result.value!.utf8)
                do {
                    //Decoding the Result as a JSON for easy use, as said in the documentation of Swift 4.1
                    let genreJSON = try JSON(data: encodedString)
                    self.genreParsing(with: genreJSON)
                } catch {return}
            }
            else {
                print("Error attempting to get data \(String(describing: response.result.error))")
            }
        }
        self.isDataLoading = false
    }
    
    //MARK: - JSON Parsing
    
    func genreParsing(with json: JSON){
        if let data = json["genres"].array{
            for jsonIndex in 0..<data.count {
                let allGenres = Genres()
                allGenres.id = (data[jsonIndex]["id"].stringValue)
                allGenres.type = (data[jsonIndex]["name"].stringValue)
                genre.append(allGenres)
            }
        }
    }
    
    func jsonParsing(with json : JSON) {
        if let data = json["results"].array{
            for jsonIndex in 0..<data.count {
                let allMovies = Movies()
                allMovies.title = (data[jsonIndex]["title"].stringValue)
                allMovies.overview = (data[jsonIndex]["overview"].stringValue)
                allMovies.posterPath = (data[jsonIndex]["poster_path"].stringValue)
                allMovies.releaseDate = (data[jsonIndex]["release_date"].stringValue)
                for genreIndex in 0..<genre.count {
                    let movieId = data[jsonIndex]["genre_ids"][0].stringValue
                    let genreId = genre[genreIndex].id
                    if movieId == genreId {
                        allMovies.genre = genre[genreIndex].type
                    }
                }
                bankMovies.append(allMovies)
            }
            collectionView.reloadData()
        }
    }
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(index)
        if isFiltering(){
            if segue.destination is DescriptionViewController {
                let destinationVC = segue.destination as? DescriptionViewController
                let selectedIndexPath = sender as? NSIndexPath
                destinationVC?.movieTitle = searchMovies[(selectedIndexPath?.row)!].title
                destinationVC?.date = searchMovies[(selectedIndexPath?.row)!].releaseDate
                destinationVC?.movieDescription = searchMovies[(selectedIndexPath?.row)!].overview
                destinationVC?.posterUrl = searchMovies[(selectedIndexPath?.row)!].posterPath
                destinationVC?.genre = bankMovies[(selectedIndexPath?.row)!].genre
            }
            
        }
        else {
            if segue.destination is DescriptionViewController {
                let destinationVC = segue.destination as? DescriptionViewController
                let selectedIndexPath = sender as? NSIndexPath
                destinationVC?.movieTitle = bankMovies[(selectedIndexPath?.row)!].title
                destinationVC?.date = bankMovies[(selectedIndexPath?.row)!].releaseDate
                destinationVC?.movieDescription = bankMovies[(selectedIndexPath?.row)!].overview
                destinationVC?.posterUrl = bankMovies[(selectedIndexPath?.row)!].posterPath
                destinationVC?.genre = bankMovies[(selectedIndexPath?.row)!].genre
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension MovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if isFiltering(){
            return searchMovies.count
        }
        return bankMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! collectionCell
        cell.link = self
        
        if isFiltering(){
            Alamofire.request(baseImageUrl+fileSize+searchMovies[indexPath.row].posterPath).responseImage { response in
                if let imageJs = response.result.value {
                    cell.setCollectionCell(image: imageJs, text: self.searchMovies[indexPath.row].title)
                }
            }
        } else {
            Alamofire.request(baseImageUrl+fileSize+bankMovies[indexPath.row].posterPath).responseImage { response in
                if let imageJs = response.result.value {
                    cell.setCollectionCell(image: imageJs, text: self.bankMovies[indexPath.row].title)
                }
            }
        }
        
        if !isDataLoading && indexPath.row == bankMovies.count - 2 {
            isDataLoading = true
            pageCount += 1
            page = String(pageCount)
            SVProgressHUD.show()
            startRequest(url: (baseUrl+apiKey+endPoint+page))
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }
        return cell
    }
}


// MARK: UICollectionViewDelegate

extension MovieViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath)   -> Bool {
        performSegue(withIdentifier: "details", sender: indexPath)
        return true
    }
    
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: (view.frame.width/2)*1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}


//MARK: - Search Bar Methods
extension MovieViewController : UISearchBarDelegate {
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            collectionView.reloadData()
        } else {
            searchMovies = bankMovies.filter({( movies : Movies) -> Bool in
                return movies.title.lowercased().contains(searchText.lowercased())
            })
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchMovies = bankMovies.filter({( movies : Movies) -> Bool in
            return movies.title.lowercased().contains(searchText.lowercased())
            } as! (Movies?) -> Bool)
        collectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
}

