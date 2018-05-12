//
//  SearchService.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/01/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Artist: NSObject, NSCoding {
    
    
    var name: String?
    var id: Int?
    var image: String?

    init(name: String?, id: Int?, image: String?) {
        self.name = name
        self.id = id
        self.image = image
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.id = decoder.decodeObject(forKey: "id") as? Int ?? 0
        self.image = decoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(id, forKey: "id")
        coder.encode(image, forKey: "image")
    }
}

class SearchService {
    static let baseURL = "https://api.discogs.com/"
    static let databaseSearch = "database/search"
    
    static func getArtist(name: String, completion: @escaping (Artist) -> Void) {
        let parameters: Parameters = [
            "q" : name,
            "type" : "artist",
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(baseURL+databaseSearch, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
                let firstArtist = Artist(name: responseJson["results"][0]["title"].stringValue, id: responseJson["results"][0]["id"].intValue, image: responseJson["results"][0]["thumb"].stringValue)
                completion(firstArtist)
            }
        })
    }
}
