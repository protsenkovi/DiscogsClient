//
//  AuthorizeService.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/01/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import Foundation
import OAuthSwift

class AuthorizeService {
    
    static var token = ""
    static var tokenSecret = ""
    
    static func authorize(completionOnSuccess: @escaping () -> ()) -> OAuth1Swift {
        let oauthswift = OAuth1Swift(
            consumerKey:    "GRotkKVHOslgzJkcAcdG",
            consumerSecret: "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh",
            requestTokenUrl: "https://api.discogs.com/oauth/request_token",
            authorizeUrl:    "https://www.discogs.com/oauth/authorize",
            accessTokenUrl:  "https://api.discogs.com/oauth/access_token"
        )
        
        oauthswift.authorize(
            withCallbackURL: URL(string: "discogs-client://Learning.Discogs-Client")!,
            success: { credential, response, parameters in
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                token = credential.oauthToken
                tokenSecret = credential.oauthTokenSecret
                isAuthorized = true
                completionOnSuccess()
            },
            failure: { error in
                print(error.localizedDescription)
                isAuthorized = false
            }
        )
        return oauthswift
    }
    
    static var isAuthorized = false
    
}
