//
//  NewProductViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit
import Kingfisher
import FirebaseStorage

class NewProductViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    var id: String = ""
    var imageUrlToUpdate = ""
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var priceText: UITextField!
    
    
    @IBOutlet weak var dairyText: UILabel!
    @IBOutlet weak var glutenText: UILabel!
    
    var image : UIImage?
    
    var isDairyFlag = true
    var isGlutenFreeFlag = true
    @IBOutlet weak var isDairySwitchOutlet: UISwitch!
    @IBOutlet weak var isGlutenFreeSwitchOutlet: UISwitch!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
//    @IBAction func onScreenTap(_ sender: Any) {
//        self.view.endEditing(true)
//    }
    
    
    @IBAction func isDairySwitch(_ sender: Any) {
        isDairyFlag = !isDairyFlag
        if isDairyFlag == true{
            dairyText.text = "Dairy"
        }else{
            dairyText.text = "Parve"
        }
        
    }
    @IBAction func isGlutenFreeSwitch(_ sender: Any) {
        isGlutenFreeFlag = !isGlutenFreeFlag
        if isGlutenFreeFlag == true{
            glutenText.text = "Gluten Free"
        }else{
            glutenText.text = "Contains Wheat"
        }
    }
    
    @IBOutlet weak var descriptionText: UITextField!
    
    
    
    @IBAction func editImage(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(
//            UIImagePickerController.SourceType.photoLibrary) {
//         let imagePicker = UIImagePickerController()
//         imagePicker.delegate = self
//         imagePicker.sourceType =
//            UIImagePickerController.SourceType.photoLibrary;
//         imagePicker.allowsEditing = true
//         self.present(imagePicker, animated: true, completion: nil)
//        }
    }
    
    
    @IBAction func onImageTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.photoLibrary) {
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
         imagePicker.sourceType =
            UIImagePickerController.SourceType.photoLibrary;
         imagePicker.allowsEditing = true
         self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func onScreenTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        if id != ""{
            if let image = image{
                Model.instance.saveImage(image: image,name: nameText.text!){ (url) in
                    self.saveProduct(url: url)
                }
            }else{
                self.saveProduct(url: self.imageUrlToUpdate)
            }
        }
        else{
            Model.instance.saveImage(image: image!,name: nameText.text!){ (url) in
                self.saveProduct(url: url)
            }
        }
    }
    
    func saveProduct(url:String){
        if self.id != "" {
            let product = Product.create(id: self.id, name: nameText.text!, imageUrl: url, price: Double(priceText.text!) ?? 0, isDairy: isDairyFlag, isGlutenFree: isGlutenFreeFlag, desc: descriptionText.text!)
            Model.instance.update(product: product){ () in
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            let product = Product.create(id: "1", name: nameText.text!, imageUrl: url, price: Double(priceText.text!) ?? 0, isDairy: isDairyFlag, isGlutenFree: isGlutenFreeFlag, desc: descriptionText.text!)
            Model.instance.add(product: product){ () in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
        reloadData()
//        if self.id != ""{
//            titleText.text = "Update Product"
//            Model.instance.getProduct(byId: id){ product in
//                self.nameText.text = product.name!
//                self.priceText.text = String(product.price)
//
//                self.isDairyFlag = product.isDairy
//                if self.isDairyFlag == true {
//                    self.isDairySwitchOutlet.setOn(true, animated: false)
//                }else{
//                    self.isDairySwitchOutlet.setOn(false, animated: false)
//                }
//                self.isGlutenFreeFlag = product.isGlutenFree
//                if self.isGlutenFreeFlag == true {
//                    self.isGlutenFreeSwitchOutlet.setOn(true, animated: false)
//                }else{
//                    self.isGlutenFreeSwitchOutlet.setOn(false, animated: false)
//                }
//                self.descriptionText.text = product.desc
//                self.imageUrlToUpdate = product.imageUrl!
//                let urlProduct = URL(string : self.imageUrlToUpdate)
//
//                //let storage = Storage.storage()
//                //let storageRef = storage.reference(withPath: "Media/Images/Products" + product.name!)
//                //print(urlProduct)
//                //let processor = DownsamplingImageProcessor(size:  (cell.imageView?.bounds.size)!)
//                //let processor = DownsamplingImageProcessor(size:  CGSize(width: 374, height: 219))
//                //cell.imageView?.kf.setImage(with: urlProduct)
////                self.productImage?.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .processor(processor), .transition(.fade(1)),.cacheOriginalImage]){ result in
////                }
//                self.imageView?.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .transition(.fade(1)),.cacheOriginalImage]){ result in
//                }
//                //self.productImage.contentMode = UIView.ContentMode.scaleAspectFit
//        }
//
//        // Do any additional setup after loading the view.
//        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
//    @objc func refresh(_ sender: AnyObject){
//        self.reloadData()
//    }
    
    func reloadData(){
        if self.id != ""{
            titleText.text = "Update Product"
            Model.instance.getProduct(byId: id){ product in
                self.nameText.text = product.name!
                self.priceText.text = String(product.price)
             
                self.isDairyFlag = product.isDairy
                if self.isDairyFlag == true {
                    self.isDairySwitchOutlet.setOn(true, animated: false)
                }else{
                    self.isDairySwitchOutlet.setOn(false, animated: false)
                }
                self.isGlutenFreeFlag = product.isGlutenFree
                if self.isGlutenFreeFlag == true {
                    self.isGlutenFreeSwitchOutlet.setOn(true, animated: false)
                }else{
                    self.isGlutenFreeSwitchOutlet.setOn(false, animated: false)
                }
                self.descriptionText.text = product.desc
                self.imageUrlToUpdate = product.imageUrl!
                let urlProduct = URL(string : self.imageUrlToUpdate)

                //let storage = Storage.storage()
                //let storageRef = storage.reference(withPath: "Media/Images/Products" + product.name!)
                //print(urlProduct)
                //let processor = DownsamplingImageProcessor(size:  (cell.imageView?.bounds.size)!)
                //let processor = DownsamplingImageProcessor(size:  CGSize(width: 374, height: 219))
                //cell.imageView?.kf.setImage(with: urlProduct)
//                self.productImage?.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .processor(processor), .transition(.fade(1)),.cacheOriginalImage]){ result in
//                }
                self.imageView?.kf.setImage(with: urlProduct, placeholder: UIImage(named: "product"), options: [ .transition(.fade(1)),.cacheOriginalImage]){ result in
                }
                //self.productImage.contentMode = UIView.ContentMode.scaleAspectFit
        }
        
        // Do any additional setup after loading the view.
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
