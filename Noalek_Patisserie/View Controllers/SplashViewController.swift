//
//  SplashViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 15/07/2021.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("helloooo")
//        isUserLoggedIn()
        //let seconds = 5.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)){
//            print("5 seconds..................")
//            self.isUserLoggedIn()
//        }
//        Thread.sleep(forTimeInterval: TimeInterval(seconds))
//        print("5 seconds")
//        isUserLoggedIn()
        //do{
//            sleep(3)
//            print("3 seconds..........................")
//            isUserLoggedIn()
        //}
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            print("5 seconds..................")
            self.isUserLoggedIn()
        }
    }
    
    @objc func performAction(){
        print("5 seconds..............................")
        isUserLoggedIn()
    }
    
    func isUserLoggedIn(){
        let user = Auth.auth().currentUser
        if let user = user {
            performSegue(withIdentifier: "homeFromSplash", sender: self)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let productsListViewController = storyboard.instantiateViewController(identifier: "ProductsListViewController") as! ProductsListViewController
//            if let win = UIApplication.shared.windows.filter{$0.isKeyWindow}.first{win.rootViewController = productsListViewController}
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authViewController = storyboard.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
            if let win = UIApplication.shared.windows.filter{$0.isKeyWindow}.first{win.rootViewController = authViewController}
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
