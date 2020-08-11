//
//  GlyphOutlineViewCell.swift
//  Vogue Runway
//
//  Created by Harry Stanton on 11/04/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Cocoa

class GlyphOutlineViewCell: NSView {

  @IBOutlet weak var label:  NSTextField!
  @IBOutlet weak var glyphImageView: NSImageView!
  
  var image: NSImage? {
    get {
      return glyphImageView.image
    }
    
    set (new) {
      new?.isTemplate = true
      glyphImageView.image = new
    }
  }
  
}
