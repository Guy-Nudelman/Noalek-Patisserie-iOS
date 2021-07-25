//
//  NewProductViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import UIKit
import Kingfisher

class NewProductViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate{

    var id: String = ""
    var imageUrlToUpdate = ""
    var likes: Int16 = 0
    var choosedImage: Bool = false
    var image : UIImage?
    var isDairyFlag = true
    var isGlutenFreeFlag = true
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var dairyIcon: UIImageView!
    @IBOutlet weak var glutenIcon: UIImageView!
    @IBOutlet weak var isDairySwitchOutlet: UISwitch!
    @IBOutlet weak var isGlutenFreeSwitchOutlet: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveIcon: UIButton!
    
    
    @IBAction func isDairySwitch(_ sender: Any) {
        isDairyFlag = !isDairyFlag
        if isDairyFlag == true{
            dairyIcon.image = UIImage(named: "milk")
        }else{
            dairyIcon.image = UIImage(named: "unmilk")
        }
    }
    
    @IBAction func isGlutenFreeSwitch(_ sender: Any) {
        isGlutenFreeFlag = !isGlutenFreeFlag
        if isGlutenFreeFlag == true{
            glutenIcon.image = UIImage(named: "glutenfree")
        }else{
            glutenIcon.image = UIImage(named: "gluten")
        }
    }

    @IBAction func onImageTap(_ sender: Any) { //open gallery
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func onScreenTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //choose image
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageView.image = image
        self.choosedImage = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.hideError(label: errorLabel)
        
        let error = validateFields()
        if error != nil { //invalid input
            showError(message: error!)
        }else{ //valid input
            if id != ""{ //edit product
                if let image = image{ //image was changed
                    Model.instance.saveImage(image: image,name: nameText.text!){ (url) in
                        self.saveProduct(url: url)
                    }
                }else{ //same image
                    self.saveProduct(url: self.imageUrlToUpdate)
                }
            }
            else{ //new product
                Model.instance.saveImage(image: image!,name: nameText.text!){ (url) in
                    self.saveProduct(url: url)
                }
            }
        }
    }
    
    func saveProduct(url:String){
        if self.id != "" {  //edit product
            Model.instance.update(id: self.id, name: nameText.text!, imageUrl: url, price: Double(priceText.text!) ?? 0, isDairy: isDairyFlag, isGlutenFree: isGlutenFreeFlag, desc: descriptionText.text!, likes: self.likes){ () in
                self.navigationController?.popViewController(animated: true)
            }
        }else{ //new product
            Model.instance.add(id: "1", name: nameText.text!, imageUrl: url, price: Double(priceText.text!) ?? 0, isDairy: isDairyFlag, isGlutenFree: isGlutenFreeFlag, desc: descriptionText.text!){ () in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        nameText.delegate = self
        priceText.delegate = self
        self.spinner.isHidden = true
        self.hideError(label: errorLabel)
        reloadData()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpElements()
        reloadData()
    }
    
    func reloadData(){
        if self.id != "" { //edit product
            titleText.text = "Update Product"
            self.choosedImage = true
            Model.instance.getProduct(byId: id){ product in
                
                self.nameText.text = product.name!
                self.priceText.text = String(product.price)
                self.isDairyFlag = product.isDairy
                if self.isDairyFlag == true {
                    self.isDairySwitchOutlet.setOn(true, animated: false)
                    self.dairyIcon.image = UIImage(named: "milk")
                }else{
                    self.isDairySwitchOutlet.setOn(false, animated: false)
                    self.dairyIcon.image = UIImage(named: "unmilk")
                }
                self.isGlutenFreeFlag = product.isGlutenFree
                if self.isGlutenFreeFlag == true {
                    self.isGlutenFreeSwitchOutlet.setOn(true, animated: false)
                    self.glutenIcon.image = UIImage(named: "glutenfree")
                }else{
                    self.isGlutenFreeSwitchOutlet.setOn(false, animated: false)
                    self.glutenIcon.image = UIImage(named: "gluten")
                }
                self.descriptionText.text = product.desc
                self.imageUrlToUpdate = product.imageUrl!
                self.likes = product.likes
                let urlProduct = URL(string : self.imageUrlToUpdate)
                let resource = ImageResource(downloadURL: urlProduct!,cacheKey: product.imageUrl!)
                self.imageView.kf.setImage(with: resource, options: [.transition(.fade(1))])
            }
        }
    }
    
    func validateFields() -> String?{
        var error:String? = nil

        //Check that all fields are filled
        if nameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            priceText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            descriptionText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            choosedImage == false {
                error = "Please fill all fields and choose an image from gallery"
        }
        return error
    }
    
    //restrict input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        
        case 1: //product name max length is 25
            guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else{
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 25
            
        case 2: //price contains only digits
            let allowedCharacters = "0123456789"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: typedCharacterSet)
            
        default:
            return true
        }
    }
    
    
    //show error and hide spinner
    func showError(message : String){
        spinner.isHidden = true
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func hideError(label: UILabel){
        label.text = "Error"
        label.alpha = 0
    }
    
    func setUpElements(){
        Inputs.newProductTextFieldSetUp(txtField: nameText, imageName: "cake")
        Inputs.newProductTextFieldSetUp(txtField: priceText, imageName: "dollar")
        Inputs.newProductTextFieldSetUp(txtField: descriptionText, imageName: "description")
        Inputs.styleFilledButton(saveIcon)
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
