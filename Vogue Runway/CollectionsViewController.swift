//
//  CollectionsViewController.swift
//  Vogue Runway
//
//  Created by Harry Stanton on 11/04/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Cocoa

class CollectionsViewController: NSViewController {
  
  let x = RunwayAPI()
  @IBOutlet weak var outlineView: NSOutlineView!
  var brands = [Brand]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.x.updateBrands()
    
    
    outlineView.register(NSNib(nibNamed: "GlyphOutlineViewCell", bundle: nil), forIdentifier: .init("glyphCell"))
    outlineView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
    outlineView.tableColumns.forEach {
      $0.resizingMask = .autoresizingMask
    }
    
    updateData(completion: nil)
    
    // Core Data

    
    outlineView.dataSource = self
    outlineView.delegate = self
    outlineView.sizeLastColumnToFit()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
//    outlineView.reloadItem(brands[10], reloadChildren: false)
  }
  
  var skip = [String]()
  
}

extension CollectionsViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    let view = outlineView.makeView(withIdentifier: .init("glyphCell"), owner: self) as! GlyphOutlineViewCell
    
    view.glyphImageView.image = NSImage(named: "test")!
    
    if let brand = item as? Brand {
      view.label.stringValue = brand.name!
    } else if let collection = item as? Collection {
      view.label.stringValue = collection.title!
    } else {
      return nil
    }
    
    return view
  }
  
  
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if item == nil {
      return brands.count
    } else if let brand = item as? Brand {
      
      let count = brand.collections!.allObjects.count
      if count > 0 {
        return count
      } else {
        updateDatabase(item: brand)
        return 0
      }
      
    }
    
    return 0
  }
  
  func updateData(completion: (() -> Void)?) {
    do {
      let context = (NSApp.delegate as! AppDelegate).persistentContainer.viewContext
      let databaseBrands = try context.fetch(Brand.fetchRequest()) as! [Brand]
      brands = databaseBrands.sorted(by: { return $0.name! < $1.name! })
      completion?()
    } catch {
      print("Fetching failed")
      completion?()
    }
  }
  
  func updateDatabase(item: Brand) {
    print("pre update children count: \(item.collections?.allObjects.count)")
    x.listCollections(brand: item) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
        do {
          let context = (NSApp.delegate as! AppDelegate).persistentContainer.viewContext
          let databaseBrands = try context.fetch(Brand.fetchRequest()) as! [Brand]
          self.brands = databaseBrands.sorted(by: { return $0.name! < $1.name! })
          
          let newBrand = self.brands.first { y in
            return y.slug! == item.slug!
          }
          
          print("after update: \(newBrand!.collections?.allObjects.count)")
        } catch let error {
          print(error)
        }
      })


    }
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    print("of item item given: \(item)")
    if item == nil {
      print("updating \(brands[index].name)")
      return brands[index]
    } else if let brand = item as? Brand {
      return (brand.collections!.allObjects as! [Collection])[index]
    } else {
      return ""
    }
    
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    if let _ = item as? Brand {
      return true
    }
    return false
  }
  
}
