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
import FirebaseDatabaseUI
import Kingfisher




class ProductsListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //AssestMana
    var data = [Product]()
    var refreshControl = UIRefreshControl()

    
    @IBOutlet weak var productsTableview: UITableView!
    
    @IBAction func addProductBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var editingFlag = false
    
    
    @IBOutlet weak var trashIcon: UIBarButtonItem!
    
    @IBAction func trashAction(_ sender: Any) {
        editingFlag = !editingFlag
        if editingFlag == true{
            trashIcon.tintColor = .red
        }else{
            trashIcon.tintColor = .link
        }
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
        //let storage = Storage.storage()
        //let storageRef = storage.reference(withPath: "Media/Images/Products" + product.name!)
        //print(urlProduct)
        //let processor = DownsamplingImageProcessor(size:  (cell.imageView?.bounds.size)!)
        //let processor = DownsamplingImageProcessor(size:  CGSize(width: 274, height: 149))
        //cell.imageView?.kf.setImage(with: urlProduct)
//        cell.imageView?.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .processor(processor),.transition(.fade(1)),.cacheOriginalImage]){ result in
//        }
        cell.productImage.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .transition(.fade(1)),.cacheOriginalImage]){ result in
        }
        //cell.item = data[indexPath.row]
        
//
//        let getDataTask = URLSession.shared.dataTask(with: urlProduct!, completionHandler: {data,_,error in
//            DispatchQueue.main.async {
//                cell.imageView?.image = UIImage(data: data!)
////                cell.imageView?.clipsToBounds = false
////                cell.imageView?.translatesAutoresizingMaskIntoConstraints = true //enable auto layout
////                //cell.imageView?.layer.cornerRadius = cell.imageView?.frame.size.width =
//
//            }
//        })
//        getDataTask.resume()
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
//        Model.instance.getAllProducts{
//            products in
//            self.data = products
//            self.productsTableview.reloadData()
//        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableview.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        reloadData()
        Model.instance.notificationProductList.observe {
            self.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(_ sender: AnyObject){
        self.reloadData()
    }
    
    func reloadData(){
        refreshControl.beginRefreshing()
        Model.instance.getAllProducts{products in
            self.data = products
            self.productsTableview.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 318
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editingFlag
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = data[indexPath.row]
            Model.instance.delete(product: product){
                //TODO: verify delete in FB
                self.data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }else if editingStyle == .insert{
            //TODO: create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "infoSegue", sender: (productsTableview.dequeueReusableCell(withIdentifier: "myProductRow", for: indexPath) as! ProductsTableViewCell).infoBtn(_:))
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "infoSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProductInfoViewController {
            let selectedRow = (sender as? Int)!
            if let productID = data[selectedRow].id {
                destination.id = productID
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let dest = segue.destination as! ProductInfoViewController
//
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
