//
//  BandViewControllerService.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 25/01/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Album {
    var image: String?
    var title: String?
    var id: Int?
    var year: Int?
    var tracklist = [String]()
    var qualityImage = ""
    
    init(image: String, title: String, id: Int, year: Int) {
        self.image = image
        self.title = title
        self.id = id
        self.year = year
    }
    
    static let baseURL = "https://api.discogs.com/"
    
    func getAlbumDetails(completion: @escaping() -> ()) {
        let albumUrl = "masters/\(id!)"
        let parameters: Parameters = [
        "key" : "GRotkKVHOslgzJkcAcdG",
        "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(Album.baseURL+albumUrl, method: .get, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
                self.qualityImage = responseJson["images"][0]["uri"].stringValue
                for (_, track) in responseJson["tracklist"] {
                    self.tracklist.append(track["title"].stringValue)
                }
                completion()
            }
        })
    }
   
    static func getArtistImages(artistId: Int, completion: @escaping ([String]) -> Void) {
        let artistUrl = "artists/\(artistId)"
        let parameters: Parameters = [
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(baseURL+artistUrl, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
//                print(responseJson)
                var artistImageList = [String]()
                
                for (_, image) in responseJson["images"] {
                    let artistImage = image["resource_url"].stringValue
                    artistImageList.append(artistImage)
                }
                completion(artistImageList)
            }
        })
    }
    
    static func getAlbums(artistId: Int, completion: @escaping ([Album]) -> Void) {
        let artistReleaseUrl = "artists/\(artistId)/releases"
        let parameters: Parameters = [
            "sort" : "year",
            "per_page" : "400",
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(baseURL+artistReleaseUrl, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
//                print(responseJson)
                var albumsList = [Album]()
                for (_, release) in responseJson["releases"] {
                    let album = Album(image: release["thumb"].stringValue, title: release["title"].stringValue, id: release["id"].intValue, year: release["year"].intValue)
                    albumsList.append(album)
                }
                completion(albumsList)
            }
        })
    }
}


