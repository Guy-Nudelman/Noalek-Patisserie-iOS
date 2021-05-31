//
//  ProductsListViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit

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
       // cell.imageView = product.imageUrl
//        cell.productImage = product
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
        return cell
        
    }
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Model.instance.getAll{
            products in
            self.data = products
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
