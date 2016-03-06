//
//  SearchResultCell.swift
//  Gourmand
//
//  Created by alireza ghias on 3/5/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var availableTime: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var estimatedShipping: UILabel!
}