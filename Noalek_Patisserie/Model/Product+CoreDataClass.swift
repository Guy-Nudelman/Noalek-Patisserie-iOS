//
//  Product+CoreDataClass.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//
//

import CoreData
import UIKit
import Firebase
import Foundation

@objc(Product)
public class Product: NSManagedObject {

 
    
    static func create(id:String, name:String, imageUrl:String, price:Double, isDairy:Bool, isGlutenFree:Bool, desc:String,lastUpdated:Int64 = 0)->Product{
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let product = Product(context: context)
        product.id = id
        product.name = name;
        product.imageUrl = imageUrl
        product.price = price
        product.isDairy = isDairy
        product.isGlutenFree = isGlutenFree
        product.likes = 0
        product.desc = desc
        product.lastUpdated = lastUpdated
        return product
        }
    
    static func create(json:[String:Any])->Product?{
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let product = Product(context: context)
        product.id = json["id"] as? String
        product.name = json["name"] as? String
        product.imageUrl = json["imageUrl"] as? String
        product.price = json["price"] as? Double ?? 0
        product.isDairy = json["isDairy"] as? Bool ?? true
        product.isGlutenFree = json["isGlutenFree"] as? Bool ?? false
        product.likes=0
        product.desc = json["desc"] as? String
        product.lastUpdated = 0
        if let lup = json["lastUpdated"] as? Timestamp{
            product.lastUpdated = lup.seconds
        }
        return product
    }
    
    static func create(product: Product) ->Product{
        return create(id: product.id!, name: product.name!, imageUrl: product.imageUrl!, price: product.price, isDairy: product.isDairy, isGlutenFree: product.isGlutenFree, desc: product.desc!, lastUpdated: product.lastUpdated)
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id!
        json["name"] = name!
        if let imageUrl = imageUrl{
            json["imageUrl"] = imageUrl
        
        }else{
            json["imageUrl"] = ""
        }
        json["price"] = price
        json["isDairy"] = isDairy
        json["isGlutenFree"] = isGlutenFree
        json["likes"] = likes
        json["desc"] = desc
        json["lastUpdated"] = FieldValue.serverTimestamp()
        return json
        
    }
    static func saveLastUpdate(time:Int64){
            UserDefaults.standard.set(time, forKey: "lastUpdate")
        }
        static func getLastUpdate()->Int64{
            return Int64(UserDefaults.standard.integer(forKey: "lastUpdate"))
        }
    
}


extension Product{


    
     static func getAll(callback:@escaping ([Product])->Void){
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
    func save(){
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        do{
            try context.save()
            
        }catch{
            
        }
        
    }
    
    func addProductToLocalDb(){
        let product = Product.create(product: self)
        product.save()
    }
    
    func delete(){
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(self)
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
    
}


