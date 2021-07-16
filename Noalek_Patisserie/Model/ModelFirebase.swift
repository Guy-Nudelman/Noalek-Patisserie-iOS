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
                        //var products = [Product]()
                        for snap in snapshot.documents{
                            if let product = Product.create(json:snap.data()){
                                products.append(product)
                            }
                        }
                        //callback(products)
                        //return
                    }
                }
                //callback([Product]())
            callback(products)
        }
    }
        
    func add(product:Product , callback: @escaping ()->Void){
            var ref: DocumentReference? = nil
            let db = Firestore.firestore()
         ref =   db.collection("products").addDocument(data: product.toJson()){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                }else{
                    
                    print("Document successfully written! \(ref!.documentID)")
//                    db.collection("products").document(ref?.documentID ?? "1").setData(["id":ref?.documentID], merge : true)
                    db.collection("products").document(ref!.documentID).setData(["id":ref!.documentID], merge : true)
                    product.id=ref?.documentID
                    
                }
            callback()
            }
        }
    
    func addLike(productId: String, uid:String , callback:@escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("likes").addDocument(data:["ProductId":productId, "UserId":uid]){ error in
            if error != nil{
                print("Error writing document: \(error)")
            }else{
                print("Document successfully written")
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
                                print("like deleted successfully")
                            }
                        }
                   }
                }
                callback()
        }
    }
    
    func update(product: Product, callback:@escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("products").document(product.id!).setData(product.toJson()){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            }else {
                print("Document successfully written")
            }
            callback()
        }
    }
    
    func updateProductLike(productId: String, addingLike: Bool, callback: @escaping (Int)->Void){
        
        let db = Firestore.firestore()
        let docRef = db.collection("products").document(productId)
        docRef.getDocument{(document,error) in
            if let document = document , document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //let dataDescription = document.data()
                print("likes*************")
                var num = document.data()!["likes"]
                if addingLike == true{
                    num = num as! Int + 1
                }else{
                    num = num as! Int - 1
                }
                
                docRef.updateData([
                    "likes": num as! Int, "lastUpdated": FieldValue.serverTimestamp()
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("likes Document successfully updated")
                    }
                }
                callback(num as! Int)
            }
            
            
        }

    }
        
        func delete(product:Product){
            let db = Firestore.firestore()
            db.collection("products").document(product.id!).updateData([
                "isRemoved": true, "lastUpdated": FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
//            db.collection("products").document(product.id!).delete() { err in
//                print(product.id! + "deleted")
//                if let err = err {
//                    print("Error removing document: \(err)")
//                } else {
//                    print("Document successfully removed!")
//                }
//            }

        }
        
        func getProduct(byId:String, callback:@escaping (Product)->Void){
            let db = Firestore.firestore()
            let docRef = db.collection("products").document(byId)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    //print("****Document data: \(document.data()!)")
                    callback(Product.create(json: document.data()!)!)
                } else {
                    print("Document does not exist")
                }
            }
        }
    
    func getRole(byId: String, callback: @escaping (String)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(byId)
        docRef.getDocument{(document,error) in
            if let document = document , document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //let dataDescription = document.data()
                print("***********")
                callback(document.data()!["role"] as! String)
                //callback(dataDescription?["role"] ?? "")
            }
            
        }
        //callback()
    }
    
    func getName(byId: String, callback: @escaping (String)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(byId)
        docRef.getDocument{(document,error) in
            if let document = document , document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //let dataDescription = document.data()
                print("***********")
                callback(document.data()!["FirstName"] as! String)
                //callback(dataDescription?["role"] ?? "")
            }
            
        }
        //callback()
    }
    
    
    static func saveImage(image:UIImage,name:String, callback:@escaping (String)->Void){
     let storageRef = Storage.storage().reference(forURL:
     "gs://noalek-patisserie-149d4.appspot.com/Media/Images/Products")
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
     print("url: \(downloadURL)")
     callback(downloadURL.absoluteString)
     }
     }
     }
    
    func isLiked(productId: String, uid:String, callback:@escaping (Bool)->Void){
        let db = Firestore.firestore()
        let docRef = db.collection("likes").whereField("UserId", isEqualTo: uid).whereField("ProductId", isEqualTo: productId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    callback(false)
                } else {
                    print(String(querySnapshot!.documents.count))
                    if querySnapshot!.documents.count > 0 {
                        callback(true)
                    }else{
                        callback(false)
                    }
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                    }
                }
                
        }
        
        
        
    }
    
}
