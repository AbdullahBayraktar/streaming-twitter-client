//
//  Request.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 30/07/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import OAuthSwift

public typealias ProgressHandler = (_ data: Data) -> Void
public typealias CompletionHandler = (_ responseData: Data?, _ response: HTTPURLResponse?, _ error: NSError?) -> Void

/**
 Streaming request handler.
 */

class StreamingRequest: NSObject, URLSessionDataDelegate {
    
    //MARK: Properties
    
    var session: URLSession?
    var task: URLSessionDataTask?
    let originalRequest: URLRequest
    let delegate: StreamingDelegate
    
    //MARK: Initializer
    
    public init(_ request: URLRequest,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default,
                queue: OperationQueue? = nil) {
        originalRequest = request
        delegate = StreamingDelegate()
        session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
        task = session?.dataTask(with: request)
    }

    //MARK: Public Methods
    
    func start() -> StreamingRequest {
        task?.resume()
        return self
    }
    
    func stop() -> StreamingRequest {
        task?.cancel()
        return self
    }
    
    func progress(_ progress: @escaping ProgressHandler) -> StreamingRequest {
        delegate.progress = progress
        return self
    }
    
    func completion(_ completion: @escaping CompletionHandler) -> StreamingRequest {
        delegate.completion = completion
        return self
    }
}

//MARK:  StreamingDelegate

class StreamingDelegate: NSObject, URLSessionDataDelegate {
    
    fileprivate let serial = DispatchQueue(label: "AB.TwitterClient.TwitterStreamingRequest", attributes: [])
    
    var response: HTTPURLResponse!
    
    let dataParser = DataParser(delimiter: "\r\n")
    
    fileprivate var progress: ProgressHandler?
    fileprivate var completion: CompletionHandler?
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        serial.sync {
            self.dataParser.append(data)
            while let data = self.dataParser.next() {
                if data.count > 0 {
                    self.progress?(data)
                }
            }
        }
    }
    
    @nonobjc func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            fatalError("didReceiveResponse is not NSHTTPURLResponse")
        }
        self.response = httpURLResponse
        
        if httpURLResponse.statusCode == 200 {
            completionHandler(.allow)
        } else {
            DispatchQueue.main.async(execute: {
                self.completion?(self.dataParser.data, httpURLResponse, nil)
            })
        }
    }
    
    @nonobjc func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(
                Foundation.URLSession.AuthChallengeDisposition.useCredential,
                URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async(execute: {
            self.completion?(self.dataParser.data, self.response, error as NSError?)
        })
    }
}
