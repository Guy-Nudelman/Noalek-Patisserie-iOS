//
//  Model.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//

import Foundation
import UIKit
import CoreData

class Model{
    static let instance = Model()
    private init(){}
        
    func getAll(callback:@escaping ([Product])->Void){
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       let request = Product.fetchRequest() as NSFetchRequest<Product>
       
       DispatchQueue.global().async {
           var data = [Product]()
           do{
               data = try context.fetch(request)
           }catch{
               
           }
           DispatchQueue.main.async {
               callback(data)
           }
       }
   }
    func add(product: Product){
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       do{
           try context.save()
       }catch{
           
       }
       
   }
   
   func delete(product: Product){
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       context.delete(product)
       do{
           try context.save()
       }catch{
           
       }
       
   }
   static func getProduct(byId:String)->Product?{
       let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       let request = Product.fetchRequest() as NSFetchRequest<Product>
       request.predicate = NSPredicate(format: "id == \(byId)")
       do{
           let products = try context.fetch(request)
           if(products.count>0){
               return products[0]
           }
       }catch{
           
       }
       return nil
   }
    
//    func getAllProducts(callback:@escaping ([Product])->Void){
//        Product.instance.getAll(callback: callback)
//    }
//
//    func add(product:Product){
//    }
//
//    func delete(product:Product){
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        context.delete(product)
//        do{
//            try context.save()
//        }catch{
//
//        }
//    }
//
//    func getProduct(byId:String)->Product?{
//return nil
//    }
}
