//
//  ProductsListViewController.swift
//  Noalek_Patisserie
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos
import FirebaseStorageUI
import SDWebImageSwiftUI
import FirebaseDatabaseUI

class ProductsListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //AssestMana
    var data = [Product]()
    @IBOutlet weak var productsTableview: UITableView!
    
    @IBAction func addProductBtn(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableview.dequeueReusableCell(withIdentifier: "myProductRow", for: indexPath) as! ProductsTableViewCell
        let product = data[indexPath.row]
        cell.nameLabel.text = product.name
        cell.priceLabel.text = String(product.price)
        if(product.isDairy == false){
            cell.isDairyIcon.image = UIImage(named: "unmilk")
        }
        else{
            cell.isDairyIcon.image = UIImage(named: "milk")
        }
        if(product.isGlutenFree == true){
            cell.isGlutenFreeIcon.image = UIImage(named: "glutenfree")
        }else{
            cell.isGlutenFreeIcon.image = UIImage(named: "gluten")
        }
        cell.likesNumber.text = String(product.likes)
        let urlProduct = URL(string : product.imageUrl!)
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "Media/Images/Products" + product.name!)
        print(urlProduct)
        let getDataTask = URLSession.shared.dataTask(with: urlProduct!, completionHandler: {data,_,error in
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data!)
//                cell.imageView?.clipsToBounds = false
//                cell.imageView?.translatesAutoresizingMaskIntoConstraints = true //enable auto layout
//                //cell.imageView?.layer.cornerRadius = cell.imageView?.frame.size.width =

            }
        })
        getDataTask.resume()
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Model.instance.getAllProducts{
            products in
            self.data = products
            for product in products{
                print("id \(product.id)")
            }
            self.productsTableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 318
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
