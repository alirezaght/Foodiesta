//
//  AddressBar.swift
//  Gourmand
//
//  Created by alireza ghias on 2/28/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation

class AddressBar : MPGTextField, MPGTextFieldDelegate{
    //MARK:init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mDelegate = self
    }
    //MARK: override Functions
    func dataForPopoverInTextField(textField: MPGTextField) -> [Dictionary<String, AnyObject>]{
        let search = textField.text
        let soap = Soap()
        if(search != nil){
            soap.findAddress(search!, completeHandler: {
                var result = [Dictionary<String, AnyObject>]()
                for value in soap.dict.values{
                    var dict = [String:String]()
                    dict["DisplayText"] = value
                    dict["DisplaySubText"] = value
                    //          dict["CustomObject"] = AnyObject
                    result.append(dict)
                }
                super.data = result
                super.provideSuggestions()
                
            })
        }
        return []

    }
    
}
