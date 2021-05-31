//
//  ModelFirebase.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 31/05/2021.
//

import Foundation
import Firebase

class Modelfirebase{
    func getAllProducts(callback:@escaping ([Product])->Void){
            let db = Firestore.firestore()
            db.collection("products").getDocuments { snapshot, error in
                if let err = error{
                    print("Error reading document: \(err)")
                }else{
                    if let snapshot = snapshot{
                        var products = [Product]()
                        for snap in snapshot.documents{
                            if let st = Product.create(json:snap.data()){
                                products.append(st)
                            }
                        }
                        callback(products)
                        return
                    }
                }
                callback([Product]())
            }
            
        }
        
        func add(product:Product){
            var ref: DocumentReference? = nil
            let db = Firestore.firestore()
         ref =   db.collection("products").addDocument(data: product.toJson()){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                }else{
                    
                    print("Document successfully written! \(ref!.documentID)")
                }
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
}
