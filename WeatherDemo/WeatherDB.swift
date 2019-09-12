//
//  WeatherDB.swift
//  WeatherDemo
//
//  Created by Rakib Hasan Suvo on 11/9/19.
//  Copyright © 2019 Rakib Hasan Suvo. All rights reserved.
//

import RealmSwift

// MARK: Model

final class City: Object {
    dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var lat = 0.0
    @objc dynamic var long = 0.0
    //let items = List<Task>()
    
}


