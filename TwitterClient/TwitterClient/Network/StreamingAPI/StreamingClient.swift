//
//  StreamingClient.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 30/07/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import OAuthSwift

/**
 Streaming Client for Twitter, able to make requests.
 */

protocol StreamingClient {
    
    func makeRequest(_ url: String, parameters: Dictionary<String, String>) -> URLRequest
}

extension StreamingClient {
    
    func streaming(_ url: String, parameters: Dictionary<String, String> = [:]) -> StreamingRequest {
        return StreamingRequest(makeRequest(url, parameters: parameters))
    }
}

class OAuthClient: StreamingClient {
    
    static var serializeIdentifier = "OAuth"
    
    let consumerKey: String
    let consumerSecret: String
    let oAuthCredential: OAuthSwiftCredential
    
    //MARK: Initializer
    
    public init(consumerKey: String,
                consumerSecret: String,
                accessToken: String,
                accessTokenSecret: String) {
        
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        let credential = OAuthSwiftCredential(consumerKey: consumerKey,
                                              consumerSecret: consumerSecret)
        credential.oauthToken = accessToken
        credential.oauthTokenSecret = accessTokenSecret
        self.oAuthCredential = credential
    }
    
    convenience init(serializedString string: String) {
        let parts = string.components(separatedBy: "\t")
        self.init(consumerKey: parts[1],
                  consumerSecret: parts[2],
                  accessToken: parts[3],
                  accessTokenSecret: parts[4])
    }
    
    var serialize: String {
        return [OAuthClient.serializeIdentifier,
                consumerKey,
                consumerSecret,
                oAuthCredential.oauthToken,
                oAuthCredential.oauthTokenSecret].joined(separator: "\t")
    }

    func makeRequest(_ urlString: String, parameters: Dictionary<String, String>) -> URLRequest {
        let url = URL(string: urlString)!
        let authorization = oAuthCredential.authorizationHeader(method: .POST,
                                                                url: url,
                                                                parameters: parameters)
        let headers = ["Authorization": authorization]
        
        let request: URLRequest
        do {
            request = try OAuthSwiftHTTPRequest.makeRequest(url:
                url, method: .POST, headers: headers, parameters: parameters, dataEncoding: String.Encoding.utf8) as URLRequest
        } catch let error as NSError {
            fatalError("invalid request error:\(error.description)")
        } catch {
            fatalError("invalid request unknwon error")
        }
        
        return request
    }
}
