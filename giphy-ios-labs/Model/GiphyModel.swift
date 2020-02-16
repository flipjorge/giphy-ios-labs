//
//  GiphyModel.swift
//  giphy-ios-labs
//
//  Created by Filipe Jorge on 16/02/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import Foundation

struct GiphyRandom : Codable
{
    var data : GiphyData
}

struct GiphyData : Codable
{
    var id : String
    var url : String
    var title : String
    var username : String
    var images : GiphyImages
}

struct GiphyImages : Codable
{
    var downsized_large : GiphyImage
    var downsized_still : GiphyImage
}

struct GiphyImage : Codable
{
    var width : String
    var height : String
    var size : String
    var url : String
}
