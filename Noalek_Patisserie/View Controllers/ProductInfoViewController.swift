//
//  ProductInfoViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 06/07/2021.
//

import UIKit
import Kingfisher


protocol MyCustomCellDelegator{
    func callSegueFromCell(myData dataobject: Any)
}


class ProductInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MyCustomCellDelegator {
    
    var id: String = "" //productId
    var isLiked: Bool = false
    var data = [Comment]()
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var likeBtnOutlet: UIButton!
    @IBOutlet weak var likesNumber: UILabel!
    @IBOutlet weak var isDairyIcon: UIImageView!
    @IBOutlet weak var isGlutenFreeIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editProductBtnOutlet: UIBarButtonItem!
    
    
    func callSegueFromCell(myData dataobject: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "NewCommentViewController") as! NewCommentViewController
        vc.id = dataobject as! String
        vc.productId = self.id
        self.present(vc, animated: true, completion: nil)
    }


    @IBAction func addCommentButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addComment", sender: self)
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserView()
        Validation.isAdmin(){ isAdminFlag in
            if isAdminFlag == true{
                self.loadAdminView()
            }
        }
        
        commentsTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        reloadData()
        Model.instance.notificationProductInfo.observe {
            self.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewProductViewController { //edit product
            destination.id = self.id
        }
        if let destination = segue.destination as? NewCommentViewController{ //new comment
            destination.productId = self.id
        }
    }

    @objc func refresh(_ sender: AnyObject){
        self.reloadData()
    }
    
    func reloadData(){
        
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
            let resource = ImageResource(downloadURL: urlProduct!,cacheKey: product.imageUrl!)
            self.productImage.kf.setImage(with: resource, options: [.transition(.fade(1))])

            //reload Comments Table
            self.refreshControl.beginRefreshing()
            Model.instance.getAllComments(byProductId: product.id!){ comments in
                self.data = comments
                self.commentsTableView.reloadData()
                self.refreshControl.endRefreshing()
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
    
    func loadAdminView(){
        self.editProductBtnOutlet.isEnabled = true
        self.editProductBtnOutlet.tintColor = .link
    }
    
    func loadUserView(){
        self.editProductBtnOutlet.isEnabled = false
        self.editProductBtnOutlet.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "myCommentRow", for: indexPath) as! CommentsTableViewCell
        let comment = data[indexPath.row]
        cell.contentView.backgroundColor = UIColor.clear
        cell.deleteCommentIcon.tintColor = .link
        cell.delegate = self
        cell.id = comment.id!
        cell.userNameLabel.text = comment.userName
        cell.commentLabel.text = comment.desc

        let user = Model.instance.getCurrentUser()
        if let user = user {
            if user.uid == comment.userId{
                cell.enableCommentButtons()
            }else{
                cell.disableCommentButtons()
            }
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

