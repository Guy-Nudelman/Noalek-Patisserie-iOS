//
//  ProductsTableViewCell.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit

class ProductsTableViewCell: UITableViewCell{

    var id: String = ""
    var isLiked: Bool = false
    let user: Any? = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var likeBtnOutlet: UIButton!
    @IBOutlet weak var likesNumber: UILabel!
    @IBOutlet weak var isDairyIcon: UIImageView!
    @IBOutlet weak var isGlutenFreeIcon: UIImageView!
    
    
    @IBAction func likeBtn(_ sender: Any) {
        
        let user = Model.instance.getCurrentUser()
        if let user = user {
            let uid = user.uid
            if self.isLiked == false{ //like
                Model.instance.addLike(productId: id, uid: uid){
                    Model.instance.updateProductLike(productId: self.id, addingLike: true){ likes in
                        self.likesNumber.text = String(likes)
                        self.isLikedAlready()
                    }
                }
            }else{ //deslike
                Model.instance.deleteLike(productId: id, uid: uid){
                    Model.instance.updateProductLike(productId: self.id, addingLike: false){ likes in
                        self.likesNumber.text = String(likes)
                        self.isLikedAlready()
                    }
                }
            }
        }
    }
    
    func isLikedAlready() -> Void{
        let user = Model.instance.getCurrentUser()
        if let user = user {
            let uid = user.uid
            Model.instance.isLiked(productId: id, uid: uid){ isLiked in
                self.isLiked = isLiked
                if self.isLiked == true{
                    self.likeBtnOutlet.imageView?.image = UIImage(named: "like")
                }else{
                    self.likeBtnOutlet.imageView?.image = UIImage(named: "dislike")
                }
            }
        }
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

