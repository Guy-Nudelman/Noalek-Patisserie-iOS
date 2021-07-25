//
//  Model.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import Foundation
import UIKit
import CoreData
import Firebase

class NotificationGeneral{
    let name: String
    
    init(name: String){
        self.name = name
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(name), object: self)
    }
    
    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(name), object: nil, queue: nil){(notification) in
            callback()
        }
    }
}


class Model{
    static let instance = Model()
    let modelFirebase = Modelfirebase()
    
    private init(){ //remove deleted records from local db
        Product.removeDeleted()
        Comment.removeDeleted()
    }
    
    public let notificationProductList = NotificationGeneral(name: "notificationProductList")
    public let notificationLogin = NotificationGeneral(name: "notificationLogin")
    public let notificationProductInfo = NotificationGeneral(name: "notificationProductInfo")
    public let notificationAdmin = NotificationGeneral(name: "notificationAdmin")
    public let notificationComment = NotificationGeneral(name: "notificationComment")
        
 
    func getAllProducts(callback:@escaping ([Product])->Void){
        
        // get last update date
        let lastUpdateDate = Product.getLastUpdate()

        // get all updated records from firebase
        modelFirebase.getAllProducts(since: lastUpdateDate ){ (products) in
            var lastUpdate:Int64 = 0
            
            for product in products{
                if (lastUpdate < product.lastUpdated){
                    lastUpdate = product.lastUpdated
                }
            }
            
            //update the local last update date
            Product.saveLastUpdate(time: lastUpdate)
            
            //save context in local db
            if products.count > 0 {products[0].save()}

            //read the complete products list from the local DB
            Product.getAll(callback: callback)
        }
    }
    
    func getAllComments(byProductId: String, callback:@escaping ([Comment])->Void){
        
        // get last update date
        let lastUpdateDate = Comment.getLastUpdate()
 
        // get all updated records from firebase
        modelFirebase.getAllComments(since: lastUpdateDate ){ comments in
            
            var lastUpdate:Int64 = 0
            
            for comment in comments{
                if (lastUpdate < comment.lastUpdated){
                    lastUpdate = comment.lastUpdated
                }
            }
            
            //update the local last update date
            Comment.saveLastUpdate(time: lastUpdate)
            
            //save context in local db
            if comments.count > 0 {comments[0].save()}

            //read the complete comments list for -specific product- from the local DB
            Comment.getAll(byProductId: byProductId, callback: callback)
        }
    }
    
    //add product
    func add(id:String, name:String, imageUrl: String, price: Double, isDairy:Bool, isGlutenFree:Bool,desc:String,callback:@escaping ()->Void){
        let product = Product.create(id: id, name: name, imageUrl: imageUrl, price: price, isDairy: isDairy, isGlutenFree: isGlutenFree, desc: desc)
        modelFirebase.add(product: product){
            self.notificationProductList.post()
            callback()
        }
    }
    
    
    func addComment(id:String, userName:String, userId:String, productId:String, desc:String, callback:@escaping ()->Void){
        let comment = Comment.create(id: id, userName: userName, userId: userId, productId: productId, desc: desc)
        modelFirebase.addComment(comment: comment){
            self.notificationProductInfo.post()
            callback()
        }
    }
    
    func addLike(productId : String, uid: String, callback:@escaping ()->Void){
        modelFirebase.addLike(productId: productId , uid:uid, callback: callback)
    }

    func deleteLike (productId : String, uid: String, callback:@escaping ()->Void){
        modelFirebase.deleteLike(productId: productId , uid:uid, callback: callback)
    }
    
    //update product
    func update(id:String, name:String, imageUrl:String, price: Double, isDairy: Bool, isGlutenFree:Bool, desc:String, likes:Int16, callback:@escaping ()->Void){
        let product = Product.create(id: id, name: name, imageUrl: imageUrl, price: price, isDairy: isDairy, isGlutenFree: isGlutenFree, desc: desc, likes: likes)
        modelFirebase.update(product: product){
            self.notificationProductInfo.post()
            self.notificationProductList.post()
            callback()
        }
    }
    
    func updateComment(id:String, userName:String, userId:String, productId:String, desc:String, callback:@escaping ()->Void){
        let comment = Comment.create(id: id, userName: userName, userId: userId, productId: productId, desc: desc)
        modelFirebase.updateComment(comment: comment){
            self.notificationProductInfo.post()
            callback()
        }
        
    }
    
    
    func updateProductLike(productId: String, addingLike: Bool,callback:@escaping (Int)->Void){
        modelFirebase.updateProductLike(productId: productId, addingLike: addingLike){ likes in
            callback(likes)
        }
    }

    //delete product
    func delete(product:Product, callback:@escaping ()->Void){
        product.isRemoved = true
       // product.save()
        modelFirebase.update(product: product){
            callback()
            self.notificationProductList.post()
            //callback()
        }

    }
    
    func deleteComment(comment:Comment, callback:@escaping ()->Void){
        comment.isRemoved = true
        //comment.save()
        modelFirebase.updateComment(comment: comment){
            self.notificationProductInfo.post()
            callback()
        }
    }
    
    func getProduct(byId:String, callback:@escaping (Product)->Void){
        modelFirebase.getProduct(byId: byId, callback: callback)
    }
    
    func getComment(byId:String, callback:@escaping (Comment)->Void){
        modelFirebase.getComment(byId: byId, callback: callback)
    }
    
    func saveImage(image:UIImage,name:String, callback:@escaping (String)->Void){
        Modelfirebase.saveImage(image: image, name: name, callback: callback)
    }
    
    func getRole(userId: String, callback: @escaping (String)->Void){
        modelFirebase.getRole(byId: userId, callback: callback)
    }
    
    func getName(userId: String, callback: @escaping (String)->Void){
        modelFirebase.getName(byId: userId, callback: callback)
    }
    
    func getFullName(userId: String, callback: @escaping (String, String)-> Void){
        modelFirebase.getFullName(byId: userId, callback: callback)
    }
    
    func isLiked(productId: String, uid:String, callback:@escaping (Bool)->Void){
        modelFirebase.isLiked(productId: productId, uid: uid){ isLiked in
            callback(isLiked)
        }
    }
    
    func getCurrentUser()-> User? {
        return modelFirebase.getCurrentUser()
    }
    
    func signIn(email: String, password: String, callback: @escaping (AuthDataResult?, Error?)->Void){
        modelFirebase.signIn(email: email, password: password, callback: callback)
    }
    
    func signOut(callback: @escaping()->Void){
        modelFirebase.signOut(callback: callback)
    }
    
    func createUser(email: String, password: String, callback: @escaping (AuthDataResult?, Error?)->Void){
        modelFirebase.createUser(email: email, password: password, callback: callback)
    }
    
    func addUser(userId: String, firstName: String, lastName: String, callback:@escaping (Error?)->Void){
        modelFirebase.addUser(userId: userId, firstName: firstName, lastName: lastName, callback: callback)
    }
    
}

