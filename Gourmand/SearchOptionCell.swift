//
//  SearchOptionCell.swift
//  Gourmand
//
//  Created by alireza ghias on 3/5/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
class   SearchOptionCell: UITableViewCell{
    
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    var filter:Filter?
    
    
    @IBAction func switchChanged(sender: UISwitch) {
        if(filter != nil){
            if(sender.on){
                SearchOptionController.selectedFilters.append(filter!)
            }else{
                if let index = SearchOptionController.selectedFilters.indexOf({ (f) -> Bool in
                    return f.objectId == filter!.objectId
                }){
                    SearchOptionController.selectedFilters.removeAtIndex(index)
                }
            }
        }
    }
}