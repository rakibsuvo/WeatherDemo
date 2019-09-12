//
//  SearchCityViewController.swift
//  WeatherDemo
//
//  Created by Rakib Hasan Suvo on 7/9/19.
//  Copyright © 2019 Rakib Hasan Suvo. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift         


class SearchCityViewController: UITableViewController, UISearchBarDelegate {
    
    var weather: Weather?
    
    @IBOutlet weak var SearchPlace: UISearchBar!
    var location : LocationElement?
    var locations = [LocationElement]()
    var searchController: UISearchController!
    
   // var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SearchPlace.delegate = self
        SearchPlace.placeholder = "Search for Cities"
       // SearchPlace.setShowsCancelButton(true, animated: true)
      // LocationInfo()
        
       // tableView.delegate = self
        
    }
    
//    func configureSearchController() {
//        // Initialize and perform a minimum configuration to the search controller.
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search here..."
//        searchController.searchBar.delegate = self as? UISearchBarDelegate
//        searchController.searchBar.sizeToFit()
//
//
//    }
    
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.navigationController!.navigationBar.isHidden = true
//        var r = self.view.frame
//        r.origin.y = -44
//        r.size.height += 44
//
//        self.view.frame = r
//        SearchPlace.setShowsCancelButton(true, animated: true)
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        SearchPlace.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchPlace.showsCancelButton = false
        SearchPlace.text = ""
        SearchPlace.resignFirstResponder()
    }
    
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        SearchPlace.setShowsCancelButton(false, animated: true)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         print("searchText \(searchText)")
        let search = SearchPlace.text!
        LocationInfo(Searchvalue: search)
    }
    
    
    
//    func searchBarSearchButtonClicked _ searchBar: UISearchBar) {
//        print("searchText \(searchBar.text ?? "nil")")
//    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weather Status"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
//
//        cell.textLabel?.text = "Weather \(indexPath.section) Row \(indexPath.row)"
//
//        return cell
//    }
    
    
    func LocationInfo(Searchvalue : String)
    {
        let  url = "https://api.apixu.com/v1/search.json?key=17561ed88aec4432b3181846190909&q=\(Searchvalue)"

        Alamofire.request(url,method: .get).responseData
            {
                response in
                if response.result.isFailure, let error = response.result.error {
                    print(error)
                }

                if response.result.isSuccess, let value = response.result.value {
                    //print(value)

                    do
                    {
                        let cities = try JSONDecoder().decode([LocationElement].self, from: value)
                        //print("\(cities.name) with \(cities.country)")

                        DispatchQueue.main.async {
                            self.locations = cities
                            self.tableView.reloadData()
                        }
                        //print(cities)


                    }
                    catch
                    {
                        print(error)
                    }
                }
        }
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        let loc = locations[indexPath.row]
        
        //cell.textLabel?.text = "City \(String(describing: loc?.name)) Row \(indexPath.row)"
        
//        cell.textLabel?.text = "City \(String(describing: loc.name)) Row \(indexPath.row)"
        
        cell.textLabel?.text = "\(String(describing: loc.name))"
        cell.detailTextLabel?.text = "\(String(loc.lat)), \(String(loc.lon))"
        //print("\(String(describing: weather?.currently.summary))")
        
        //cell.textLabel?.text = (weather?.currently.summary).map { $0.rawValue }
        //cell.textLabel?.text = "Weather \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
    
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath)
        let realm = try! Realm()
        let weatherDBObject = City()
        if let CityName = cell?.textLabel?.text , let lat_lon = cell?.detailTextLabel?.text
        {
            let separatedLatLon = lat_lon.components(separatedBy: CharacterSet(charactersIn: ","))
            if let  lat = separatedLatLon.first , let lon = separatedLatLon.last{
//                let latitude = (lat as NSString).doubleValue
//                let longitude = (lon as NSString).doubleValue
                let latitude = Double(lat)
                let longitude = Double(lon)
                weatherDBObject.name = CityName
                weatherDBObject.lat = latitude ?? 6.6
                weatherDBObject.long = longitude ?? 5.5
                
                try! realm.write {
                    realm.add(weatherDBObject)
                   // realm.objects(weatherDBObject).uniqueValue("\(CityName)", type: String.self)
                    //realm.objects(weatherDBObject).
//                    var checkCity = weatherDBObject.objectsWhere("id == %@", primaryKeyValueHere).firstObject()
//
//
//
//                    if checkCity {
//                        //don't add
//                    } else {
//                        //add our object to the DB
//                    }
                    
                }
                
                print(Realm.Configuration.defaultConfiguration.fileURL!) // for database location
                //dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                
            }
            
            
        }


    }
    
    
    
    


}

//Realm().objects(Item).uniqueValue("name", type: String.self)

//extension AddCityTableVC {
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let cell = tableView.cellForRow(at: indexPath)
//        let realm = try! Realm()
//        let city = City()
//
//        // TODO: - Get name, latitude & longitude
//        if let nameOfCity = cell?.textLabel?.text, let latLan = cell?.detailTextLabel?.text {
//            let sepletLan = latLan.split(separator: ",")
//            if let lat = sepletLan.first, let lon = sepletLan.last {
//
//                let latVal = (lat as NSString).doubleValue
//                let lonVal = (lon as NSString).doubleValue
//
//                city.name = nameOfCity
//                city.latitude = latVal
//                city.longitude = lonVal
//
//                // TODO: - Check duplicate data existence
//                let predicate = NSPredicate(format: "name = %@", nameOfCity )
//                let cityObj = realm.objects(City.self).filter(predicate)
//
//                if cityObj.count == 0 {
//                    // MARK: - Insert unique value to City Model
//                    try! realm.write {
//                        realm.add(city)
//                    }
//                }
//
//                print(Realm.Configuration.defaultConfiguration.fileURL!) // for database location
//                dismiss(animated: true, completion: nil)
//            }
//
//        }
//    }
//
//}

