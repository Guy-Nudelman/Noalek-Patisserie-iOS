//
//  Inputs.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 15/07/2021.
//

import Foundation
import UIKit

class Inputs{
    
   static func textFieldSetUp(txtField: UITextField, imageName: String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 20))
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
        imageContainerView.addSubview(imageView)
        txtField.leftView = imageContainerView
        txtField.leftViewMode = .always
        imageView.tintColor = UIColor.init(red: 255/255, green: 36/255, blue: 222/255, alpha: 1)
    }
    
    static func newProductTextFieldSetUp(txtField: UITextField, imageName: String){
         let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 20))
         imageView.image = UIImage(named: imageName)
         let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
         imageContainerView.addSubview(imageView)
         txtField.leftView = imageContainerView
         txtField.leftViewMode = .always
         imageView.tintColor = UIColor.init(red: 255/255, green: 36/255, blue: 222/255, alpha: 1)
     }
 
    static func styleFilledButton(_ button:UIButton){
        button.layer.cornerRadius = 34.5
    }
    
    static func styleHollowButton(_ button: UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(red: 255/255, green: 36/255, blue: 222/255, alpha: 1).cgColor
        button.layer.cornerRadius = 33
    }
    
    static func styleCancelButton(_ button: UIButton){
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.link.cgColor
        button.layer.cornerRadius = 13
    }
    
    static func styleSaveButton(_ button: UIButton){
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.init(red: 255/255, green: 36/255, blue: 222/255, alpha: 1).cgColor
        button.layer.cornerRadius = 13
    }
    
}
