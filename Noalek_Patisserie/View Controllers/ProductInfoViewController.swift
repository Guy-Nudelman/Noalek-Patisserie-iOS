//
//  ProductInfoViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 06/07/2021.
//

import UIKit
import Kingfisher
import FirebaseStorage
import Firebase


class ProductInfoViewController: UIViewController {

    var id: String = ""
    var isLiked: Bool = false
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var productInfoView: UIScrollView!
    
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
    
    @IBAction func addToCartBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var isDairyIcon: UIImageView!
    
    @IBOutlet weak var isGlutenFreeIcon: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var editProductBtnOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserView()
        
        Validation.isAdmin(){ isAdminFlag in
            if isAdminFlag == true{
                self.loadAdminView()
            }
        }
        
//        let user = Auth.auth().currentUser
//        if let user = user {
//          // The user's ID, unique to the Firebase project.
//          // Do NOT use this value to authenticate with your backend server,
//          // if you have one. Use getTokenWithCompletion:completion: instead.
//          let uid = user.uid
//            Model.instance.getRole(userId: uid) { role in
//                if role == "admin"{
//                    self.loadAdminView()
//                }
//            }
//        }
        
        
        //productInfoView.addSubview(refreshControl)
        //refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        reloadData()
        Model.instance.notificationProductInfo.observe {
            self.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewProductViewController {
            destination.id = self.id
        }
    }

    @objc func refresh(_ sender: AnyObject){
        self.reloadData()
    }
    
    func reloadData(){
        //refreshControl.beginRefreshing()
        Model.instance.getProduct(byId: id){ product in
            
            self.nameLabel.text = product.name!
            
            self.priceLabel.text = String(product.price) + " $"
            if(product.isDairy == false){
                self.isDairyIcon.image = UIImage(named: "unmilk")
            }
            else{
                self.isDairyIcon.image = UIImage(named: "milk")
            }
            if(product.isGlutenFree == true){
                self.isGlutenFreeIcon.image = UIImage(named: "glutenfree")
            }else{
                self.isGlutenFreeIcon.image = UIImage(named: "gluten")
            }
            
            self.likesNumber.text = String(product.likes)
            self.isLikedAlready()
            self.descriptionLabel.text = product.desc
            let urlProduct = URL(string : product.imageUrl!)

            let processor = DownsamplingImageProcessor(size:  CGSize(width: 374, height: 219))
            self.productImage.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .processor(processor), .transition(.fade(1)),.cacheOriginalImage]){ result in
            }
            
            //self.refreshControl.endRefreshing()
            //self.productImage.contentMode = UIView.ContentMode.scaleAspectFit
        }
    }
    
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
    
    
    func loadAdminView(){
        self.editProductBtnOutlet.isEnabled = true
        self.editProductBtnOutlet.tintColor = .link
    }
    
    func loadUserView(){
        self.editProductBtnOutlet.isEnabled = false
        self.editProductBtnOutlet.tintColor = UIColor.clear
    }
    
//    func reloadData(){
//        refreshControl.beginRefreshing()
//        Model.instance.getAllProducts{products in
//            self.data = products
//            self.productsTableview.reloadData()
//            self.refreshControl.endRefreshing()
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    }

