//
//  ViewController.swift
//  giphy-ios-labs
//
//  Created by Filipe Jorge on 15/02/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import UIKit
import SwiftyGif
import Combine

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
        _refreshImage(withKey: _giphyKey!, tags: tags)
    }

    
    //MARK: Giphy Key
    private var _giphyKey: String?
    
    
    //MARK: Image
    @IBOutlet var imageView: UIImageView!
    
    private var _currentDataTask : AnyCancellable?
    
    private func _refreshImage(withKey key: String, tags: String?) -> Void
    {
        //cancels current task if exists
        _currentDataTask?.cancel()
        _currentDataTask = nil
        
        //request random gif
        let urlSession = URLSession.shared
        
        guard let encodedURLString = "https://api.giphy.com/v1/gifs/random?api_key=\(key)&tag=\(tags ?? "")&rating=G".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("Error encoding url string")
            return
        }
        
        guard let url = URL(string: encodedURLString) else {
            print("Error creating URL")
            return
        }
        
        enum HTTPError: LocalizedError
        {
            case statusCode
            case mimeType
        }
        
        loaderView.startAnimating()
        
        _currentDataTask = urlSession.dataTaskPublisher(for: url).tryMap { output in
            //check response
            guard let httpResponse = output.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                print("Status code for respose != 200")
                throw HTTPError.statusCode
            }
            
            guard let mime = httpResponse.mimeType, mime == "application/json" else {
                print("Not returning a json")
                throw HTTPError.mimeType
            }
            
            return output.data
        }
        .decode(type: GiphyRandom.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .sink(receiveCompletion: { completion in
            switch(completion)
            {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
            //
            self._currentDataTask = nil
        }, receiveValue: { value in
            //load and show image
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let imageData = try? Data(contentsOf: URL(string: value.data.images.downsized_large.url)!) else {
                    print ("Some error getting image data")
                    return
                }
                
                DispatchQueue.main.async {
                    guard let image = try? UIImage(gifData:imageData) else {
                        print("Unable to create UIImage from imageData")
                        return
                    }
                    
                    self?.imageView.setGifImage(image)
                    self?.loaderView.stopAnimating()
                }
            }
        })
    }
    
    
    //MARK: Refresh Button
    @IBAction func _buttonTouchedUpInside()
    {
        guard let key = _giphyKey else {
            print("Giphy Key is required")
            return
        }
        
        _refreshImage(withKey: key, tags: tags)
    }
    
    
    //MARK: Tags
    var tags:String?
    
    @IBAction func tagsCancel(_ segue: UIStoryboardSegue)
    {
        //
    }
    
    @IBAction func tagsDone(_ segue: UIStoryboardSegue)
    {
        guard let tagsViewController = segue.source as? TagsViewController else {
            return
        }
        
        tags = tagsViewController.tags
        
        //refresh
        guard let key = _giphyKey else {
            print("Giphy Key is required")
            return
        }
        
        _refreshImage(withKey: key, tags: tags)
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tagsViewController = segue.destination as? TagsViewController else {
            return
        }
        
        tagsViewController.tags = tags
    }
    
    
    //MARK: Loader
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
}
