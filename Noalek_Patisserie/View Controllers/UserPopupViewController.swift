//
//  UserPopupViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 18/07/2021.
//

import UIKit

class UserPopupViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var popupWindow: UIView!
    @IBOutlet weak var signoutIcon: UIButton!
    @IBOutlet weak var continueIcon: UIButton!
    
    
    @IBAction func continueButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signoutButton(_ sender: Any) {
        Model.instance.signOut(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let splashViewController = storyboard.instantiateViewController(identifier: "splashViewController") as! SplashViewController
            if let win = UIApplication.shared.windows.filter{$0.isKeyWindow}.first{win.rootViewController = splashViewController}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpElements()
        let user = Model.instance.getCurrentUser()
        if let user = user {
            let uid = user.uid
            Model.instance.getFullName(userId: uid){ firstName, lastName in
                self.welcomeLabel.text = "Hi " + firstName + " " + lastName + " !"
            }
        }
    }
    
    func setUpElements(){
        Inputs.styleCancelButton(continueIcon)
        Inputs.styleSaveButton(signoutIcon)
        popupWindow.layer.cornerRadius = 10
        image.layer.cornerRadius = 10
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
