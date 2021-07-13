//
//  Model.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import Foundation
import UIKit
import CoreData

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
    
    private init(){
        Product.removeDeleted()
    }
    
    public let notificationProductList = NotificationGeneral(name: "notificationProductList")
    public let notificationLogin = NotificationGeneral(name: "notificationLogin")
    public let notificationProductInfo = NotificationGeneral(name: "notificationProductInfo")
        
    let modelFirebase = Modelfirebase()
    
//    func getAllStudents(callback:@escaping ([Student])->Void){
//        modelFirebase.getAllStudents(callback: callback)
//    }
    
    func getAllProducts(callback:@escaping ([Product])->Void){
        
        // get last update date
        let lastUpdateDate = Product.getLastUpdate()
        // get all updated records from firebase
        modelFirebase.getAllProducts(since: lastUpdateDate ){ (products) in
            var lastUpdate:Int64 = 0
            
            for product in products{
                print("product \(product.id!)")
                if (lastUpdate < product.lastUpdated){
                    lastUpdate = product.lastUpdated
                }
            }
            
            //update the local last update date
            Product.saveLastUpdate(time: lastUpdate)
            
            //save context in local db
            if products.count > 0 {products[0].save()}

//            for product in products{
//                product.update(product: product)
//              
//            }


            //read the complete students list from the local DB
            Product.getAll(callback: callback)

        }
    }
    
                
    func add(product:Product,callback:@escaping ()->Void){
        //modelFirebase.add(product: product, callback: callback)
        //self.notificationProductList.post()
        modelFirebase.add(product: product){
            self.notificationProductList.post()
            callback()
        }
    }
  

    func update(product:Product,callback:@escaping ()->Void){
        //modelFirebase.update(product: product, callback: callback)
        //self.notificationProductInfo.post()
        modelFirebase.update(product: product){
            self.notificationProductInfo.post()
            callback()
        }
    }

    
    func delete(product:Product, callback:@escaping ()->Void){
        product.isRemoved = true
        //modelFirebase.update(product: product, callback: callback)
        //self.notificationProductList.post()
        modelFirebase.update(product: product){
            self.notificationProductList.post()
            callback()
        }

    }
    
    func getProduct(byId:String, callback:@escaping (Product)->Void){
        modelFirebase.getProduct(byId: byId, callback: callback)
    }
    
    func saveImage(image:UIImage,name:String, callback:@escaping (String)->Void){
        Modelfirebase.saveImage(image: image,name: name, callback: callback)
    }
}

//class Model{
//    static let instance = Model()
//    private init(){}
//    let modelFirebase = Modelfirebase()
//
//    func getAll(callback:@escaping ([Product])->Void){
//        modelFirebase.getAllProducts(callback: callback)
////       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////
////       let request = Product.fetchRequest() as NSFetchRequest<Product>
////
////       DispatchQueue.global().async {
////           var data = [Product]()
////           do{
////               data = try context.fetch(request)
////           }catch{
////
////           }
////           DispatchQueue.main.async {
////               callback(data)
////           }
////       }
//   }
//    func add(product: Product){
//        modelFirebase.add(product: product)
////       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////       do{
////           try context.save()
////       }catch{
////
////       }
//
//   }
//
//   func delete(product: Product){
//    modelFirebase.delete(product: product)
////       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////       context.delete(product)
////       do{
////           try context.save()
////       }catch{
////
////       }
//
//   }
//   static func getProduct(byId:String)->Product?{
////       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////
////       let request = Product.fetchRequest() as NSFetchRequest<Product>
////       request.predicate = NSPredicate(format: "id == \(byId)")
////       do{
////           let products = try context.fetch(request)
////           if(products.count>0){
////               return products[0]
////           }
////       }catch{
////
////       }
//       return nil
//   }
//
////    func getAllProducts(callback:@escaping ([Product])->Void){
////        Product.instance.getAll(callback: callback)
////    }
////
////    func add(product:Product){
////    }
////
////    func delete(product:Product){
////        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////        context.delete(product)
////        do{
////            try context.save()
////        }catch{
////
////        }
////    }
////
////    func getProduct(byId:String)->Product?{
////return nil
////    }
//}
