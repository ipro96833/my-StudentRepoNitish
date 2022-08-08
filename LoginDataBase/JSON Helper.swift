//
//  JSON Helper.swift
//  LoginDataBase
//
//  Created by mac on 05/08/22.
//

import Foundation

struct JSONHelper{

let id: String
let uid: String
let loc_id: String
let location_name: String
let location_address: String
let description: String
let latitude: String
let longitude: String
let created: String
let img: String
let share_url: String
let place_tags: String

init(dict:[String:String]){
    
    self.id = dict["id"] ?? "nil"
    self.uid = dict["uid"] ?? "nil"
    self.loc_id = dict["loc_id"] ?? "nil"
    self.location_name = dict["location_name"] ?? "nil"
    self.location_address = dict["location_address"] ?? "nil"
    self.description = dict["description"] ?? "nil"
    self.latitude = dict["latitude"] ?? "nil"
    self.longitude = dict["longitude"] ?? "nil"
    self.created = dict["created"] ?? "nil"
    self.img = dict["img"] ?? "nil"
    self.share_url = dict["share_url"] ?? "nil"
    self.place_tags = dict["place_tags"] ?? "nil"
        
    }
}
