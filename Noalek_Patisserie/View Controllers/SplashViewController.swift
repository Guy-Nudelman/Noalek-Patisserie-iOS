//
//  SplashViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 15/07/2021.
//

import UIKit

class SplashViewController: UIViewController {
    
    //@IBOutlet weak var gifView: UIImageView! ---> TODO: gif?
    
    @IBOutlet weak var welcomeLabel: UILabel!
    var welcomeMessage = "Welcome ..."

    @IBOutlet weak var progressView: UIProgressView!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gifView.loadGif(name: "splashbg-t") ---> TODO: gif?
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startProgress()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)){
            self.isUserLoggedIn()
        }
    }
    
    func animateLabel(){
        for i in welcomeMessage{
            welcomeLabel.text! += "\(i)"
            RunLoop.current.run(until: Date()+0.2)
        }
    }
    
    
    func startProgress(){
        var progress: Float = 0.0
        progressView.progress = progress
        timer = Timer.scheduledTimer(withTimeInterval: 0.033, repeats: true){ timer in
            progress += 0.01
            self.progressView.progress = progress
        }
    }
    
    func isUserLoggedIn(){
        let user = Model.instance.getCurrentUser()
        if user != nil {
            //performSegue(withIdentifier: "homeFromSplash", sender: self)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyboard.instantiateViewController(identifier: "HomeVC") as! UITabBarController
            if let win = UIApplication.shared.windows.filter{$0.isKeyWindow}.first{win.rootViewController = home}
            
            
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
