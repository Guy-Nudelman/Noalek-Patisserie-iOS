//
//  RegisterViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 14/07/2021.
//

import UIKit
import Foundation
import Firebase

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
    
    @IBAction func submitBtn(_ sender: Any) {
        
        hideAllErrors()
        
    //Validate the firlds
        let error = validateFields()
        
        if error != nil {
            //Error Found
            showError(message: error!)
        }else {
            //Create cleaned version of the data
            let firstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            
            
            //Create User
            Auth.auth().createUser(withEmail: email, password:password){(result,error) in
                //Check for Db error
                if error != nil {
                    //self.showError(message: "Error Creating User")
                    print(error!.localizedDescription)
                    self.showError(message: error!.localizedDescription)
                }else {
                    let db = Firestore.firestore()
//                    db.collection("users").addDocument(data: ["FirstName":firstName, "LastName":lastName, "role": "user" , "uid" : result!.user.uid]) {
//                        (error) in
//                        if error != nil{
//                            self.showError(message: "Error saving user data")
//                        }
//                    }
                    
                    db.collection("users").document(result!.user.uid).setData(["FirstName":firstName, "LastName":lastName, "role": "user" , "uid" : result!.user.uid]){ error in
                        if error != nil{
                            self.showError(message: "Error saving user data")
                        }
                    }
                    
                    //Transition to product list
                    self.performSegue(withIdentifier: "homeFromRegisterSegue", sender: self)
                    //self.transitionToHome()
                }
            }
            
            
        }
    }
    
    
    
    
//    func transitionToHome(){
//    let HomeViewController =  storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as? ProductsListViewController
//    }
    
    
    override func viewDidLoad() {
        hideAllErrors()
        
        Inputs.textFieldSetUp(txtField: firstNameText, imageName: "User")
        Inputs.textFieldSetUp(txtField: lastNameText, imageName: "User")
        Inputs.textFieldSetUp(txtField: emailText, imageName: "Mail")
        Inputs.textFieldSetUp(txtField: passwordText, imageName: "Password")
     
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    func showError(message : String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func hideError(label: UILabel){
        
        label.text = "Error"
        label.alpha = 0
        //errorLabel.text = "Error"
        //errorLabel.alpha = 0
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
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                error = "Please fill all fields"
            }
        
        //Check if first and last name are valid
        let cleanedFirstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isValidName(cleanedFirstName) == false {
            self.firstNameErrorLabel.text = "First name is not valid"
            self.firstNameErrorLabel.alpha = 1
            error = "Fix All Errors"
        }
        
        let cleanedLastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isValidName(cleanedLastName) == false {
            self.lastNameErrorLabel.text = "Last name is not valid"
            self.lastNameErrorLabel.alpha = 1
            error = "Fix All Errors"
        }
        
        //Check if email is valid
        let cleanedEmail = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isValidEmail(cleanedEmail) == false {
            self.emailErrorLabel.text =  "Email is not valid"
            self.emailErrorLabel.alpha = 1
            error = "Fix All Errors"
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Validation.isPasswordValid(cleanedPassword) == false {
            self.passwordErrorLabel.text = "Password must have 8 characters , at least one special characters"
            self.passwordErrorLabel.alpha = 1
            error = "Fix All Errors"
        }
        
        return error
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
