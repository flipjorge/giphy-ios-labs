//
//  ViewController.swift
//  giphy-ios-labs
//
//  Created by Filipe Jorge on 15/02/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting GIPHY Key
        guard let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            print("Keys.plist file with api keys is required in order to run the app")
            return
        }
        
        let keysDictionary = NSDictionary(contentsOf: URL(fileURLWithPath: keysPath)) as! Dictionary<String, AnyObject>
        
        guard let giphyKey = keysDictionary["GIPHY"] else {
            print("Can't find the GIPHY key")
            return
        }
        
        // Request random gif
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
            let decoder = JSONDecoder()
            
            guard let giphyRandomData = try? decoder.decode(GiphyRandom.self, from: data!) else {
                print("Error parsing data")
                return
            }
            
            //load and show image
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let imageData = try? Data(contentsOf: URL(string: giphyRandomData.data.images.downsized_still.url)!) else {
                    print ("Some error getting image data")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: imageData)
                }
            }
            
        }.resume()
    }


}

