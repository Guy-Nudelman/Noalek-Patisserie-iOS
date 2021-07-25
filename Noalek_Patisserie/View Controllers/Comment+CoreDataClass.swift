//
//  Comment+CoreDataClass.swift
//  
//
//  Created by Guy Nudelman on 16/07/2021.
//
//

import UIKit
import Foundation
import CoreData
import Firebase

@objc(Comment)
public class Comment: NSManagedObject {

    static func create(id:String, userName:String, userId: String, productId: String, desc:String,lastUpdated:Int64 = 0)->Comment{
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let comment = Comment(context: context)
        comment.id = id
        comment.userName = userName
        comment.userId = userId
        comment.productId = productId
        comment.desc = desc
        comment.lastUpdated = lastUpdated
        comment.isRemoved = false
        
        return comment
    }
    
    static func create(json:[String:Any])->Comment?{
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let comment = Comment(context: context)
        
        comment.id = json["id"] as? String
        comment.userName = json["userName"] as? String
        comment.userId = json["userId"] as? String
        comment.productId = json["productId"] as? String
        comment.desc = json["desc"] as? String
        comment.lastUpdated = 0
        if let lup = json["lastUpdated"] as? Timestamp{
            comment.lastUpdated = lup.seconds
        }
        comment.isRemoved = json["isRemoved"] as? Bool ?? false
        
        return comment
    }
    
    static func create(comment: Comment) ->Comment{
        return create(id: comment.id!, userName: comment.userName!, userId: comment.userId!, productId: comment.productId!, desc:comment.desc!, lastUpdated: comment.lastUpdated)
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["userName"] = userName
        json["userId"] = userId
        json["productId"] = productId
        json["desc"] = desc
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["isRemoved"] = isRemoved
        
        return json
    }
    
    static func saveLastUpdate(time:Int64){
            UserDefaults.standard.set(time, forKey: "lastUpdated")
    }
        
    static func getLastUpdate()->Int64{
            return Int64(UserDefaults.standard.integer(forKey: "lastUpdated"))
    }
        
    //get All (unremoved) Comments by productId
    static func getAll(byProductId: String, callback:@escaping ([Comment])->Void){
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
        let request = Comment.fetchRequest() as NSFetchRequest<Comment>
        let predicate1: NSPredicate = NSPredicate(format: "productId == %@","\(byProductId)")
        let predicate2: NSPredicate = NSPredicate(format: "isRemoved != true")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        
        request.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: true)]
        
        DispatchQueue.global().async {
            var data = [Comment]()
            do{
                data = try context.fetch(request)
            }catch{
            }
            DispatchQueue.main.async {
               callback(data)
           }
       }
   }
    
   func save(){
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
       do{
           try context.save()
       }catch{
       }
       
   }
   
   func addCommentToLocalDb(){
       let comment = Comment.create(comment: self)
       comment.save()
   }
   
   func delete(){
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       context.delete(self)
       do{
           try context.save()
       }catch{
       }
   }
   
   static func getComment(byId:String)->Comment?{
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       let request = Comment.fetchRequest() as NSFetchRequest<Comment>
       request.predicate = NSPredicate(format: "id == %@","\(byId)")
       do{
           let comments = try context.fetch(request)
           if(comments.count>0){
               return comments[0]
           }
       }catch{
       }
       return nil
   }
   
   static func removeDeleted(){
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       let request = Comment.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
       request.predicate = NSPredicate(format: "isRemoved == true")
       
       let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
       do{
           try context.execute(deleteRequest)
       }catch let error as NSError{
           //TODO: handle error
       }
   }
    
}
