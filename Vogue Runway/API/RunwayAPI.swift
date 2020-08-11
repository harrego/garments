//
//  RunwayAPI.swift
//  Vogue Runway
//
//  Created by Harry Stanton on 11/04/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Cocoa

class RunwayAPI {
  
  private func genericRequest(url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("*/*", forHTTPHeaderField: "Accept")
    request.addValue("Vogue%20Runway/7 CFNetwork/978.0.7 Darwin/18.5.0", forHTTPHeaderField: "User-Agent")
    
    return request
  }
  
  func updateBrands() {
    
    let runwayStrings = RunwayStrings()
    
    let url = URL(string: "\(runwayStrings.graphURL)\(runwayStrings.getBrands())")!
    let request = genericRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard error == nil else {
        print(error)
        return
      }
      
      guard let data = data else {
        print("no data")
        return
      }
      do {
        let brands = try JSONDecoder().decode(GetBrandsDecodable.self, from: data).data.allBrands.Brand
    
        let moc = (NSApp.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        moc.perform {
          do {
            for brand in brands {
              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Brand")
              fetchRequest.predicate = NSPredicate(format: "%K == %@", "slug", brand.slug)
              
              let fetchedBrands = try moc.fetch(fetchRequest) as! [Brand]
              if fetchedBrands.count > 0 {
                if fetchedBrands.first!.name! != brand.name {
                  fetchedBrands.first!.setValue(brand.name, forKey: "name")
                }
              } else {
                let entityDescription = NSEntityDescription.entity(forEntityName: "Brand", in: moc)!
                let newBrand = NSManagedObject(entity: entityDescription, insertInto: moc)
                
                newBrand.setValue(brand.name, forKey: "name")
                newBrand.setValue(brand.slug, forKey: "slug")
              }
              try moc.save()
            }
            
          } catch let error {
            print(error)
          }
        }
      } catch let error {
        print(error)
      }
    }.resume()
  }
  
  func listCollections(brand: Brand, completion: @escaping () -> Void) {
    print("list collections")
    let runwayStrings = RunwayStrings()
    
    let url = URL(string: "\(runwayStrings.graphURL)\(runwayStrings.listCollections(slug: brand.slug!))")!
    let request = genericRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard error == nil else {
        print(error)
        completion()
        return
      }
      
      guard let data = data else {
        print("no data")
        completion()
        return
      }
      
      do {
        let collections = try JSONDecoder().decode(GetCollectionsDecodable.self, from: data).data.allContent.Content
        
        let moc = (NSApp.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        moc.perform {
          do {
            let brandFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Brand")
            brandFetchRequest.predicate = NSPredicate(format: "%K == %@", "slug", brand.slug!)
            let fetchedBrands = try moc.fetch(brandFetchRequest) as! [Brand]
            let contextBrand = fetchedBrands.first!
            
            for collection in collections {
              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Collection")
              fetchRequest.predicate = NSPredicate(format: "%K == %@", "slug", collection.slug)
              
              let fetchedCollections = try moc.fetch(fetchRequest) as! [Collection]
              if fetchedCollections.count > 0 {
                // update info
              } else {
                let entityDescription = NSEntityDescription.entity(forEntityName: "Collection", in: moc)!
                let newCollection = NSManagedObject(entity: entityDescription, insertInto: moc)
                
                newCollection.setValue(collection.title, forKey: "title")
                newCollection.setValue(collection.id, forKey: "id")
                newCollection.setValue(collection.slug, forKey: "slug")
                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"
//                print(dateFormatter.date(from: collection.date!)!)
//                newCollection.setValue(dateFormatter.date(from: collection.date!)!, forKey: "date")
                newCollection.setValue(contextBrand, forKey: "brand")
              }
              try moc.save()
            }
            completion()
            
          } catch let error {
            completion()
            print(error)
          }
        }
      } catch let error {
        completion()
        print(error)
      }
    }.resume()
  }
  
}


