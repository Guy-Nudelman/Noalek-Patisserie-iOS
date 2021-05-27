//
//  NewProductViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit

class NewProductViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var priceText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func isDairySwitch(_ sender: Any) {
    }
    @IBAction func isGlutenFreeSwitch(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
        let product = Product.create(id: "1", name: nameText.text!, imageUrl: "", price: Double(priceText.text!) ?? 0, isDairy: false, isGlutenFree: true)
        //Model.instance.add(product: product)
        //Model.instance.getAll(callback: (product:(Product)->Void))
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
