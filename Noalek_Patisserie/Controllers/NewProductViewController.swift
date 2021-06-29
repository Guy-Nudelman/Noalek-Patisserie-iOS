//
//  NewProductViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit

class NewProductViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var priceText: UITextField!
    
    var image : UIImage?

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func isDairySwitch(_ sender: Any) {
    }
    @IBAction func isGlutenFreeSwitch(_ sender: Any) {
    }
    
    @IBOutlet weak var descriptionText: UITextField!
    
    @IBAction func editImage(_ sender: Any) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if let image = image{
            Model.instance.saveImage(image: image,name: nameText.text!){ (url) in
                self.saveProduct(url: url)
            }
            
        }else{
            self.saveProduct(url: "")
        }
        
       
    }
    func saveProduct(url:String){
        let product = Product.create(id: "1", name: nameText.text!, imageUrl: url, price: Double(priceText.text!) ?? 0, isDairy: false, isGlutenFree: true, desc: descriptionText.text!)
        ///let product = Product()
        Model.instance.add(product: product){ () in
            self.navigationController?.popViewController(animated: true)
        }
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
