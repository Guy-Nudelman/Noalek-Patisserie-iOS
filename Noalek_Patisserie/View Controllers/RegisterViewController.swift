//
//  RegisterViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 14/07/2021.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var submitIcon: UIButton!
    
    
    @IBAction func onScreenTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        hideAllErrors()
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil { //Error Found
            showError(message: error!)
        }else { //valid input
            //Create clean version of the data
            let firstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Model.instance.createUser(email: email, password:password){(result,error) in
                if error != nil { //error creating user
                    self.showError(message: error!.localizedDescription)
                }else{
                    Model.instance.addUser(userId: result!.user.uid, firstName: firstName, lastName: lastName){ err in
                        if err != nil{ //error saving user document
                            self.showError(message: "Error saving user data")
                        }else{ //create & save user successfully
                            //self.performSegue(withIdentifier: "homeFromRegisterSegue", sender: self)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let home = storyboard.instantiateViewController(identifier: "HomeVC") as! UITabBarController
                            if let win = UIApplication.shared.windows.filter{$0.isKeyWindow}.first{win.rootViewController = home}
                        }
                    }
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //show error and hide spinner
    func showError(message : String){
        spinner.isHidden = true
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func hideError(label: UILabel){
        label.alpha = 0
    }
    
    func hideAllErrors(){
        hideError(label: firstNameErrorLabel)
        hideError(label: lastNameErrorLabel)
        hideError(label: emailErrorLabel)
        hideError(label: passwordErrorLabel)
        hideError(label: errorLabel)
    }
    
    func validateFields() -> String?{
        var error:String? = nil
        //Check that all fields are filled
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                error = "Please fill all fields"
            }
        
        //Check if first and last name are valid
        let cleanedFirstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isValidName(cleanedFirstName) == false {
            self.firstNameErrorLabel.text = "*First name is invalid"
            self.firstNameErrorLabel.alpha = 1
            error = "Try again..."
        }
        
        let cleanedLastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isValidName(cleanedLastName) == false {
            self.lastNameErrorLabel.text = "*Last name is invalid"
            self.lastNameErrorLabel.alpha = 1
            error = "Try again..."
        }
        
        //Check if email is valid
        let cleanedEmail = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isValidEmail(cleanedEmail) == false {
            self.emailErrorLabel.text =  "*Email is invalid"
            self.emailErrorLabel.alpha = 1
            error = "Try again..."
        }
        
        //Check if the password is secured
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isPasswordValid(cleanedPassword) == false {
            self.passwordErrorLabel.text = "*Password must have 8 characters, at least one special character"
            self.passwordErrorLabel.alpha = 1
            error = "Try again..."
        }
        
        return error
    }
    
    func setUpElements(){
        self.spinner.isHidden = true
        hideAllErrors()
        Inputs.textFieldSetUp(txtField: firstNameText, imageName: "user")
        Inputs.textFieldSetUp(txtField: lastNameText, imageName: "user")
        Inputs.textFieldSetUp(txtField: emailText, imageName: "mail")
        Inputs.textFieldSetUp(txtField: passwordText, imageName: "password")
        Inputs.styleFilledButton(submitIcon)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpElements()
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
