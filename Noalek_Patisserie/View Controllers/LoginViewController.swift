//
//  LoginViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 14/07/2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    @IBAction func submitBtn(_ sender: Any) {
        hideError(label: errorLabel)
        //Validate Text Fields
        
        
        
        //Create cleaned versions of text fields
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        
        
        //Sigining the user
        Auth.auth().signIn(withEmail: email, password: password) {(result,error) in
            if error != nil{
                self.showError(message: error!.localizedDescription)
            }else {
                self.performSegue(withIdentifier: "homeFromLoginSegue", sender: self)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideError(label: errorLabel)
        
        Inputs.textFieldSetUp(txtField: emailText, imageName: "Mail")
        Inputs.textFieldSetUp(txtField: passwordText, imageName: "Password")
        
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
//
//    func hideAllErrors(){
//        hideError(label: firstNameErrorLabel)
//        hideError(label: lastNameErrorLabel)
//        hideError(label: emailErrorLabel)
//        hideError(label: passwordErrorLabel)
//        hideError(label: errorLabel)
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
