//
//  Product+CoreDataClass.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//
//

import CoreData
import UIKit

@objc(Product)
public class Product: NSManagedObject {

 
    
    static func create(id:String, name:String, imageUrl:String, price:Double, isDairy:Bool, isGlutenFree:Bool, desc:String)->Product{
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
        return product

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
        return json
        
    }
    
}


extension Product{


    
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
    func save(){
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try context.save()
        }catch{
            
        }
        
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


