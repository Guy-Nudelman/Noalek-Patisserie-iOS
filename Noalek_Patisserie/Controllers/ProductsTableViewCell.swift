//
//  ProductsTableViewCell.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit




class ProductsTableViewCell: UITableViewCell{




    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
   
    @IBOutlet weak var productImage: UIImageView!
    
    @IBAction func likeBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var likesNumber: UILabel!
    
    @IBAction func infoBtn(_ sender: Any) {
        
    }
 
    @IBAction func addToCartBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var isDairyIcon: UIImageView!
    
    @IBOutlet weak var isGlutenFreeIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    



}

