//
//  DataParser.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 04/08/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

/**
 Steaming API data parser.
 */

class DataParser {

    //MARK: Properties
    
    var data: Data
    var delimiter: Data?
    
    //MARK: Initializer

    public init(delimiter: String) {
        self.data = Data()
        self.delimiter = delimiter.data(using: String.Encoding.utf8)!
    }
    
    //MARK: Functionalities
    
    func append(_ data: Data) {
        self.data.append(data)
    }
    
    func next() -> Data? {
        
        guard let delimiter = delimiter else {
            fatalError("delimiter not found")
        }
        
        return self.next(delimiter)
    }
    
    func next(_ delimiter: Data) -> Data? {
        
        guard let range = data.range(of: delimiter) else {
            return nil
        }
        
        let line = data.subdata(in: 0..<range.lowerBound)
        data.replaceSubrange(0..<range.upperBound, with: Data())
        return line
    }
    
    func hasNext(_ delimiter: String) -> Bool {
        
        guard let delimiter = delimiter.data(using: String.Encoding.utf8) else {
            fatalError("NSUTF8StringEncoding error")
        }
        return self.hasNext(delimiter)
    }
    
    func hasNext(_ delimiter: Data) -> Bool {
        guard let _ = data.range(of: delimiter) else {
            return false
        }
        return true
    }
    
}
