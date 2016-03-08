//
//  DetailCell.swift
//  Gourmand
//
//  Created by alireza ghias on 3/8/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class DetailCell: UITableViewCell {
    
    @IBOutlet weak var kitchenImage: UIImageView!
    @IBOutlet weak var ingredientView: UIScrollView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    var cook: PFObject?
    @IBAction func addToCartClicked(sender: AnyObject) {
    }
}