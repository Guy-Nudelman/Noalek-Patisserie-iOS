//
//  ModelFirebase.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 31/05/2021.
//

import Foundation
import Firebase

class Modelfirebase{
    
    func getAllProducts(since: Int64, callback:@escaping ([Product])->Void){
        let db = Firestore.firestore()
        db.collection("products").order(by: "lastUpdated").start(at: [Timestamp(seconds: since, nanoseconds: 0)]).getDocuments { snapshot, error in
            
            var products = [Product]()
                
            if let err = error{
                    print("Error reading document: \(err)")
                }else{
                    if let snapshot = snapshot{
                        for snap in snapshot.documents{
                            if let product = Product.create(json:snap.data()){
                                products.append(product)
                            }
                        }
                    }
                }
            
            callback(products)
        }
    }
    
    
    func getAllComments(since: Int64, callback:@escaping ([Comment])->Void){
        let db = Firestore.firestore()
        db.collection("comments").order(by: "lastUpdated").start(at: [Timestamp(seconds: since, nanoseconds: 0)]).getDocuments{ snapshot, error in
            
            var comments = [Comment]()
            
            if let err = error{
                print("Error reading document: \(err)")
            }else{
                if let snapshot = snapshot{
                    for snap in snapshot.documents{
                        if let comment = Comment.create(json: snap.data()){
                            comments.append(comment)
                        }
                    }
                }
            }
            
            callback(comments)
        }
    }
    
    
     //add product
    func add(product:Product , callback: @escaping ()->Void){
            var ref: DocumentReference? = nil
            let db = Firestore.firestore()
            ref = db.collection("products").addDocument(data: product.toJson()){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                }else{
                    db.collection("products").document(ref!.documentID).setData(["id":ref!.documentID], merge : true)
                    product.id=ref?.documentID
                }
                
                callback()
            }
        }
    
    
    func addLike(productId: String, uid:String , callback:@escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("likes").addDocument(data:["ProductId":productId, "UserId":uid]){ error in
            if let error = error{
                print("Error writing document: \(error)")
            }else{
            }
            
            callback()
        }
    }
    
    
    func addComment(comment: Comment, callback:@escaping ()->Void){
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("comments").addDocument(data: comment.toJson()){ err in
            if let err = err {
                print("Error writing document: \(err)")
            }else{
                db.collection("comments").document(ref!.documentID).setData(["id":ref!.documentID], merge : true)
                comment.id=ref?.documentID
            }
            
            callback()
        }
    }
    
    
    func deleteLike(productId: String, uid:String , callback:@escaping ()->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("likes").whereField("UserId", isEqualTo: uid).whereField("ProductId", isEqualTo: productId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error deleting document: \(err)")
                }else{
                    for document in querySnapshot!.documents {
                        db.collection("likes").document(document.documentID).delete(){ err in
                            if let err = err {
                                print("Error deleting document: \(err)")
                            }else{
                            }
                        }
                   }
                }
                
                callback()
        }
    }
    
    
    //update product
    func update(product: Product, callback:@escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("products").document(product.id!).setData(product.toJson()){ err in
            if let err = err {
                print("Error writing document: \(err)")
            }else {
            }
            
            callback()
        }
    }
    
    
    func updateComment(comment: Comment, callback:@escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("comments").document(comment.id!).setData(comment.toJson()){ err in
            if let err = err {
                print("Error writing document: \(err)")
            }else {
            }
            
            callback()
        }
    }
    
    
    func updateProductLike(productId: String, addingLike: Bool, callback: @escaping (Int)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("products").document(productId)
        docRef.getDocument{(document,error) in
            
            if let document = document , document.exists {

                var num = document.data()!["likes"]
                if addingLike == true{ //like
                    num = num as! Int + 1
                }else{ //dislike
                    num = num as! Int - 1
                }
                
                docRef.updateData(["likes": num as! Int, "lastUpdated": FieldValue.serverTimestamp()]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                    }
                }
                
                callback(num as! Int)
            }
        }
    }
        
    
    //delete product
    func delete(product:Product){
        let db = Firestore.firestore()
        db.collection("products").document(product.id!).updateData(["isRemoved": true, "lastUpdated": FieldValue.serverTimestamp()]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
            }
        }
    }
    
    
    func deleteComment(comment: Comment){
        let db = Firestore.firestore()
        db.collection("comments").document(comment.id!).updateData(["isRemoved": true, "lastUpdated": FieldValue.serverTimestamp()]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
            }
        }
    }

    
    func getProduct(byId:String, callback:@escaping (Product)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("products").document(byId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                callback(Product.create(json: document.data()!)!)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func getComment(byId:String, callback:@escaping (Comment)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("comments").document(byId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                callback(Comment.create(json: document.data()!)!)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func getRole(byId: String, callback: @escaping (String)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(byId)
        docRef.getDocument{ (document,error) in
            if let document = document , document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                callback(document.data()!["role"] as! String)
            }
        }
    }
    
    
    func getName(byId: String, callback: @escaping (String)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(byId)
        docRef.getDocument{(document,error) in
            if let document = document , document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                callback(document.data()!["FirstName"] as! String)
            }
        }
    }
    
    
    func getFullName(byId: String, callback: @escaping (String, String)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(byId)
        docRef.getDocument{ (document,error) in
            if let document = document , document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let firstName: String = document.data()!["FirstName"] as! String
                let lastName: String = document.data()!["LastName"] as! String
                callback(firstName, lastName)
            }
        }
    }
    
    
    static func saveImage(image:UIImage,name:String, callback:@escaping (String)->Void){
        let storageRef = Storage.storage().reference(forURL: "gs://noalek-patisserie-149d4.appspot.com/Media/Images/Products")
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child(name)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    callback("")
                    return
                }
                callback(downloadURL.absoluteString)
            }
        }
     }
    
    
    func isLiked(productId: String, uid:String, callback:@escaping (Bool)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("likes").whereField("UserId", isEqualTo: uid).whereField("ProductId", isEqualTo: productId).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    callback(false)
                }else {
                    if querySnapshot!.documents.count > 0 {
                        callback(true)
                    }else{
                        callback(false)
                    }
                }
        }
    }
    
    
    func getCurrentUser()-> User? {
        return Auth.auth().currentUser
    }
    
 
    func signIn(email: String, password: String, callback: @escaping (AuthDataResult?, Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: callback)
    }
    
   
    func signOut(callback: @escaping()->Void){
        do{
            try Auth.auth().signOut()
            callback()
        }catch let signOutError as NSError {
            print("Error in logging out : %@",signOutError)
        }
    }
    
    
    func createUser(email: String, password: String, callback: @escaping (AuthDataResult?, Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: callback)
    }
    
    
    func addUser(userId: String, firstName: String, lastName: String, callback:@escaping (Error?)->Void){
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData(["FirstName":firstName, "LastName":lastName, "role": "user" , "uid" : userId], completion: callback)
    }

}
