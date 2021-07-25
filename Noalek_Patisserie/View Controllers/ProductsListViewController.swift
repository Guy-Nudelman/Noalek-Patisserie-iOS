//
//  ProductsListViewController.swift
//  Noalek_Patisserie
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit
import Photos
import Kingfisher

class ProductsListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var data = [Product]()
    var refreshControl = UIRefreshControl()
    var editingFlag = false
    
    @IBOutlet weak var trashIcon: UIBarButtonItem!
    @IBOutlet weak var productsTableview: UITableView!
    @IBOutlet weak var addProductBtnOutlet: UIBarButtonItem!

    
    @IBAction func addProductBtn(_ sender: Any) {
    }
    
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
        
        cell.id = product.id!
        cell.nameLabel.text = product.name
        cell.desc.text = product.desc
        cell.priceLabel.text = String(product.price) + " $"
        if(product.isDairy == false){
            cell.isDairyIcon.image = UIImage(named: "unmilk")
        }else{
            cell.isDairyIcon.image = UIImage(named: "milk")
        }
        if(product.isGlutenFree == true){
            cell.isGlutenFreeIcon.image = UIImage(named: "glutenfree")
        }else{
            cell.isGlutenFreeIcon.image = UIImage(named: "gluten")
        }
        cell.likesNumber.text = String(product.likes)
        cell.isLikedAlready()
        let urlProduct = URL(string : product.imageUrl!)!
        let resource = ImageResource(downloadURL: urlProduct,cacheKey: product.imageUrl!)
        cell.productImage.kf.setImage(with: resource, options: [.transition(.fade(1))])

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Noalek Menu"
        self.navigationItem.titleView = UIView() //hide navigarion title
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUserView()
        Validation.isAdmin(){ isAdminFlag in
            if isAdminFlag == true{
                self.loadAdminView()
            }
        }

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
        Model.instance.getAllProducts{ products in
            self.data = products
            self.productsTableview.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 345
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editingFlag
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = data[indexPath.row]
            Model.instance.delete(product: product){
                self.data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }else if editingStyle == .insert{
        }
    }
        
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
    
    func loadAdminView(){
        self.addProductBtnOutlet.isEnabled = true
        self.addProductBtnOutlet.tintColor = .link
        self.trashIcon.isEnabled = true
        self.trashIcon.tintColor = .link
    }
    
    func loadUserView(){
        self.addProductBtnOutlet.isEnabled = false
        self.addProductBtnOutlet.tintColor = UIColor.clear
        self.trashIcon.isEnabled = false
        self.trashIcon.tintColor = UIColor.clear
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
