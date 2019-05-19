//
//  Favorites.swift
//  desafioIos
//
//  Created by Felipe Silva Lima on 5/13/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import Foundation
import RealmSwift

class Favorites: Object {
    
    @objc dynamic var realmTitle: String = ""
    @objc dynamic var realmDate: String = ""
    @objc dynamic var realmDescription: String = ""
    @objc dynamic var realmPoster: String = ""
    @objc dynamic var favorite: Bool = false
    
}
