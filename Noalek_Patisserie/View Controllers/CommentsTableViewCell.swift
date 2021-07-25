//
//  CommentsTableViewCell.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 16/07/2021.
//

import UIKit
import Foundation

class CommentsTableViewCell: UITableViewCell {

    var id: String = "" //commentId
    var delegate: MyCustomCellDelegator!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var editCommentIcon: UIButton!
    @IBOutlet weak var deleteCommentIcon: UIButton!
    
    
    @IBAction func editCommentBtn(_ sender: Any) {
        let mydata = self.id
        if self.delegate != nil{
            self.delegate.callSegueFromCell(myData: mydata)
        }
    }
    
    @IBAction func deleteCommentBtn(_ sender: Any) {
        deleteCommentIcon.tintColor = .red
 
        Model.instance.getComment(byId: self.id){ comment in
            self.deleteCommentIcon.tintColor = .link
            self.contentView.backgroundColor = UIColor.init(red: 255/255, green: 136/255, blue: 136/255, alpha: 0.3)
            
            Model.instance.deleteComment(comment: comment){
            }
        }
    }
    
    func enableCommentButtons(){
        self.deleteCommentIcon.isEnabled = true
        self.deleteCommentIcon.isHidden = false
        self.editCommentIcon.isEnabled = true
        self.editCommentIcon.isHidden = false
    }
    
    func disableCommentButtons(){
        self.deleteCommentIcon.isEnabled = false
        self.deleteCommentIcon.isHidden = true
        self.editCommentIcon.isEnabled = false
        self.editCommentIcon.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
