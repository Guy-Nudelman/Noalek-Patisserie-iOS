//
//  NewCommentViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 16/07/2021.
//

import UIKit

class NewCommentViewController: UIViewController, UITextFieldDelegate {

    var id: String = "" //commentId
    var productId: String = ""
    
    @IBOutlet weak var commentWindow: UIView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveCommentIcon: UIButton!
    @IBOutlet weak var cancelCommentIcon: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    @IBAction func onScreenTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func saveCommentButton(_ sender: Any) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        if commentText.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{ //empty comment
            showError(message: "Please say something...")
        }else{ //valid comment
            let user = Model.instance.getCurrentUser()
            if let user = user {
                let uid = user.uid
                if self.id != "" { //edit comment
                    Model.instance.getComment(byId: self.id){ comment in
                        Model.instance.updateComment(id: comment.id!, userName: comment.userName!, userId: comment.userId!, productId: comment.productId!, desc: self.commentText.text!){
                        }
                    }
                }else{ //new comment
                    Model.instance.getName(userId: uid){ userName in
                        Model.instance.addComment(id: "1", userName: userName, userId: uid, productId: self.productId, desc: self.commentText.text!){
                         }
                    }
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelCommentButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(message : String){
        self.spinner.isHidden = true
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func hideError(label: UILabel){
        label.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentText.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        commentText.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpElements()
        let user = Model.instance.getCurrentUser()
        if let user = user {
            let uid = user.uid
            Model.instance.getFullName(userId: uid){ firstName, lastName in
                self.userNameLabel.text = "Hi " + firstName + " " + lastName + " !"
            }
            if self.id != "" { //edit comment
                Model.instance.getComment(byId: self.id){ comment in
                    self.commentText.text = comment.desc
                }
            }
        }
    }
    
    func setUpElements(){
        self.spinner.isHidden = true
        hideError(label: errorLabel)
        Inputs.styleSaveButton(saveCommentIcon)
        Inputs.styleCancelButton(cancelCommentIcon)
        commentWindow.layer.cornerRadius = 10
        image.layer.cornerRadius = 10
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else{
            return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 21
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
