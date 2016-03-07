//
//  SearchBar.swift
//  Gourmand
//
//  Created by alireza ghias on 3/5/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class SearchBar: MPGTextField, MPGTextFieldDelegate{
    var filters = [Filter]()
    var filterDelegate : (()->[Filter])?
    var searchDelegate: ((PFObject)->())?
    var showOptions: (()->())?
    var showResult: (()->())?
    //MARK:init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mDelegate = self
    }
    //MARK: override Functions
    func dataForPopoverInTextField(textField: MPGTextField) -> [Dictionary<String, AnyObject>]{
        let search = textField.text
        if(filterDelegate != nil){
            filters = filterDelegate!()
        }
        let searchService = SearchService(filters: filters)
        if(search != nil && !search!.isEmpty){
            searchService.searchFood(search!, completeHandler: { (objects) -> () in
                if(objects != nil){
                    var result = [Dictionary<String, AnyObject>]()
                    for obj in objects!{
                        do{
                            var dict = [String:AnyObject]()
                            dict["DisplayText"] = obj["name"] as! String
                            let category = obj["category"] as! PFObject
                            dict["DisplaySubText"] = category["name"] as! String
                            dict["CustomObject"] = obj
                            result.append(dict)
                        }catch{
                            print("could not fetch group")
                        }
                        
                    }
                    super.data = result
                    super.provideSuggestions()
                }
            })
            
        }else {
            if(showOptions != nil){
                showOptions!()
            }
            
        }
        return super.data
        
    }
    func textFieldDidEndEditing(textField: MPGTextField, withSelection data: Dictionary<String, AnyObject>) {
        if(searchDelegate != nil)
        {
            let obj = data["CustomObject"] as? PFObject
            if(obj != nil){
                if(showResult != nil){
                    showResult!()
                }
                searchDelegate!(obj!)
            }
        }
    }
    func textFieldShouldSelect(textField: MPGTextField) -> Bool {
        return true
    }
    func textFieldEmpty(textField: MPGTextField) {
        showOptions?()
    }
    
}