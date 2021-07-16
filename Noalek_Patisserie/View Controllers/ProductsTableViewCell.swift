//
//  ProductsTableViewCell.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit
import Firebase



class ProductsTableViewCell: UITableViewCell{


    var id: String = ""
    var isLiked: Bool = false

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
   
    @IBOutlet weak var productImage: UIImageView!
    
    @IBAction func likeBtn(_ sender: Any) {
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            
            //self.isLikedAlready()
            
            if self.isLiked == false{ //like action
                Model.instance.addLike(productId: id, uid: uid){
                    print("added like document")
                    Model.instance.updateProductLike(productId: self.id, addingLike: true){ likes in
                        self.likesNumber.text = String(likes)
                        self.isLikedAlready()
                        print("updated number of like to the product + 1")
                    }
                }
                
//                Model.instance.updateProductLike(productId: id, addingLike: true){ likes in
//                    self.likesNumber.text = String(likes)
//                    print("update product like callback successfully")
//                }
                
            }else{ //deslike
                Model.instance.deleteLike(productId: id, uid: uid){
                    print("deleted like document")
                    Model.instance.updateProductLike(productId: self.id, addingLike: false){ likes in
                        self.likesNumber.text = String(likes)
                        self.isLikedAlready()
                        print("updated number of like to the product - 1")
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var likeBtnOutlet: UIButton!
    
    
    @IBOutlet weak var likesNumber: UILabel!
    
    @IBAction func infoBtn(_ sender: Any) {
        
    }

    @IBAction func addToCartBtn(_ sender: Any) {
        
    }
    
    @IBOutlet weak var isDairyIcon: UIImageView!
    
    @IBOutlet weak var isGlutenFreeIcon: UIImageView!
    
    func isLikedAlready() -> Void{
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            Model.instance.isLiked(productId: id, uid: uid){ isLiked in
                self.isLiked = isLiked
                if self.isLiked == true{
                    self.likeBtnOutlet.tintColor = .red
                }
                else{
                    self.likeBtnOutlet.tintColor = .black
                }
                //is isLiked == true
                //print("*************)$#%^&%%$@#$%^$%&^*")
            }
        }
        //return isLiked
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    



}

