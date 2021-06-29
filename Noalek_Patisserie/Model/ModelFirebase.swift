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
                    db.collection("products").document(ref?.documentID ?? "1").setData(["id":ref?.documentID], merge : true)
                    
                    product.id=ref?.documentID
                    
                }
            callback()
            }
        }
        
        func delete(product:Product){
            let db = Firestore.firestore()
            db.collection("product").document(product.id!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }

        }
        
        func getProduct(byId:String)->Product?{
            
            return nil
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
    
}
