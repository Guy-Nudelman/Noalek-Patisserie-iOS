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
        txtField.leftViewMode = .always
        let imageView = UIImageView()
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.frame = CGRect(x: 5, y: 0, width: txtField.frame.width, height: txtField.frame.height)
        txtField.leftView = imageView
    }
    
    
    
    
    
    
}
