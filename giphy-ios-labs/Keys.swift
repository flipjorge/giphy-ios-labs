//
//  Keys.swift
//  giphy-ios-labs
//
//  Created by Filipe Jorge on 16/02/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import Foundation

class Keys
{
    //MARK: Singleton
    static let shared = Keys()
    
    
    //MARK: Lifecycle
    private init()
    {
        guard let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            print("Keys.plist file with api keys is required in order to run the app")
            return
        }
        
        guard let keysDictionary = NSDictionary(contentsOf: URL(fileURLWithPath: keysPath)) as? Dictionary<String, AnyObject> else {
            print("Cannot get a dictionary from Keys.plist")
            return
        }
        
        _keysDictionary = keysDictionary
    }
    
    
    //MARK: Keys
    private var _keysDictionary : Dictionary<String, AnyObject>?
    
    enum API : String {
        case giphy = "GIPHY"
    }
    
    public func getKey(for api:API) throws -> String
    {
        guard let key = _keysDictionary?[api.rawValue] as? String else {
            print("Can't find \(api.rawValue) key")
            throw KeysError.NotFound
        }
        
        return key
    }
}

//MARK: Errors
enum KeysError : Error {
    case NotFound
}
