//
//  AppDelegate.swift
//  giphy-ios-labs
//
//  Created by Filipe Jorge on 15/02/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Getting GIPHY Key
        guard let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            print("Keys.plist file with api keys is required in order to run the app")
            return true
        }
        
        let keysDictionary = NSDictionary(contentsOf: URL(fileURLWithPath: keysPath)) as! Dictionary<String, AnyObject>
        
        guard let giphyKey = keysDictionary["GIPHY"] else {
            print("Can't find the GIPHY key")
            return true
        }
        
        //Request random gif
        let urlSession = URLSession.shared
        let url = URL(string: "https://api.giphy.com/v1/gifs/random?api_key=\(giphyKey)&tag=&rating=G")
        urlSession.dataTask(with: url!) { data, response, error in
            
            //check error
            if error != nil {
                print(error!)
                return
            }
            
            //check response
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else
            {
                print("Status code for respose != 200")
                return
            }
            
            guard let mime = httpResponse.mimeType, mime == "application/json" else {
                print("Not returning a json")
                return
            }
            
            //parse data
            do
            {
                let decoder = JSONDecoder()
                let giphyRandomData = try decoder.decode(GiphyRandom.self, from: data!)
                
                print (giphyRandomData.data.images.downsized_still.url)
                
            } catch {
                print("Error parsing data: \(error.localizedDescription)")
            }
            
        }.resume()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

