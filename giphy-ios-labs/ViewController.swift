//
//  ViewController.swift
//  giphy-ios-labs
//
//  Created by Filipe Jorge on 15/02/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController
{
    //MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //getting GIPHY Key
        do {
            _giphyKey = try Keys.shared.getKey(for: .giphy)
        } catch KeysError.NotFound {
            print("Giphy Key not found")
            return
        } catch {
            print("Unknown error getting giphy key")
            return
        }
        
        //refresh
        _refreshImage(withKey: _giphyKey!)
    }

    
    //MARK: Giphy Key
    private var _giphyKey : String?
    
    
    //MARK: Image
    @IBOutlet var imageView: UIImageView!
    
    private func _refreshImage(withKey key : String) -> Void
    {
        //request random gif
        let urlSession = URLSession.shared
        let url = URL(string: "https://api.giphy.com/v1/gifs/random?api_key=\(key)&tag=&rating=G")
        urlSession.dataTask(with: url!) { data, response, error in
            
            //check error
            if error != nil {
                print(error!)
                return
            }
            
            //check response
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
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
                guard let imageData = try? Data(contentsOf: URL(string: giphyRandomData.data.images.downsized_large.url)!) else {
                    print ("Some error getting image data")
                    return
                }
                
                DispatchQueue.main.async {
                    guard let image = try? UIImage(gifData:imageData) else {
                        print("Unable to create UIImage from imageData")
                        return
                    }
                    
                    self?.imageView.setGifImage(image)
                }
            }
            
        }.resume()
    }
    
    
    //MARK: Refresh Button
    @IBAction func _buttonTouchedUpInside()
    {
        guard let key = _giphyKey else {
            print("Giphy Key is required")
            return
        }
        
        _refreshImage(withKey: key)
    }
    
    
    //MARK: Tags Button
    @IBAction func _tagsButtonTouchedUpInside()
    {
        //open tags modal view
    }
}
