//
//  ProductInfoViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 06/07/2021.
//

import UIKit
import Kingfisher
import FirebaseStorage



class ProductInfoViewController: UIViewController {

    var id: String = ""
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var productInfoView: UIScrollView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBAction func likeBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var likesNumber: UILabel!
    
    @IBAction func addToCartBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var isDairyIcon: UIImageView!
    
    @IBOutlet weak var isGlutenFreeIcon: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productInfoView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
        refreshControl.beginRefreshing()
        Model.instance.getProduct(byId: id){ product in
            self.nameLabel.text = product.name!
            self.priceLabel.text = String(product.price)
            
            
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
            self.descriptionLabel.text = product.desc
            
            let urlProduct = URL(string : product.imageUrl!)
            //let storage = Storage.storage()
            //let storageRef = storage.reference(withPath: "Media/Images/Products" + product.name!)
            //print(urlProduct)
            //let processor = DownsamplingImageProcessor(size:  (cell.imageView?.bounds.size)!)
            let processor = DownsamplingImageProcessor(size:  CGSize(width: 374, height: 219))
            //cell.imageView?.kf.setImage(with: urlProduct)
            self.productImage.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .processor(processor), .transition(.fade(1)),.cacheOriginalImage]){ result in
            }
            
            self.refreshControl.endRefreshing()
            //self.productImage.contentMode = UIView.ContentMode.scaleAspectFit
        }
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

