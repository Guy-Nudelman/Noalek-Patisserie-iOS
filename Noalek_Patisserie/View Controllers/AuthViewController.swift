//
//  AuthViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 14/07/2021.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    
    @IBAction func loginBtn(_ sender: Any) {
    }
    
    
    @IBAction func registerBtn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
            print("Emaillllll------" + email!)
//            if Model.getRole(userId: uid) == "admin"{
//                self.addProductBtnOutlet.isEnabled = true
//            }else{
//                self.addProductBtnOutlet.isEnabled = false
//            }
          // ...
        }else{
            print("No User")
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
