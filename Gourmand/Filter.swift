//
//  Filter.swift
//  Gourmand
//
//  Created by alireza ghias on 3/1/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
class Filter{
    enum Type{
        case Ingredient
        case Category
    }
    
    let type: Type
    let objectId: String
    let name: String
    init(type: Type, objectId: String, name: String){
        self.type = type
        self.objectId  = objectId
        self.name = name
    }
}
