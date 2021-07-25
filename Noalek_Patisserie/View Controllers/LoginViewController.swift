//
//  LoginViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 14/07/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var submitIcon: UIButton!
    
    
    @IBAction func onScreenTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        hideError(label: errorLabel)
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        //Create clean versions of text fields
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Model.instance.signIn(email: email, password: password) { (result, error) in
            if error != nil{
                self.showError(message: error!.localizedDescription)
            }else {
                //self.performSegue(withIdentifier: "homeFromLoginSegue", sender: self)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let home = storyboard.instantiateViewController(identifier: "HomeVC") as! UITabBarController
                if let win = UIApplication.shared.windows.filter{$0.isKeyWindow}.first{win.rootViewController = home}
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func showError(message : String){
        self.spinner.isHidden = true
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func hideError(label: UILabel){
        label.alpha = 0
    }
    
    func setUpElements(){
        self.spinner.isHidden = true
        hideError(label: errorLabel)
        Inputs.textFieldSetUp(txtField: emailText, imageName: "mail")
        Inputs.textFieldSetUp(txtField: passwordText, imageName: "password")
        Inputs.styleHollowButton(submitIcon)
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
