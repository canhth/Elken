//
//  CarTableViewCell.swift
//  Elken
//
//  Created by Canh Tran on 9/28/17.
//  Copyright © 2017 Canh Tran. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCellWithModel(car: Car) {
        carNameLabel.text = car.name
        priceLabel.text = car.price
        brandLabel.text = car.brand
    }
    
}
