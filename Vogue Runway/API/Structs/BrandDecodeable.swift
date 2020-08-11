//
//  BrandDecodeable.swift
//  Vogue Runway
//
//  Created by Harry Stanton on 11/04/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Foundation

struct GetBrandsDecodable: Decodable {
  var data: AllBrandsDecodable
}

struct AllBrandsDecodable: Decodable {
  var allBrands: BrandArrayDecodable
}

struct BrandArrayDecodable: Decodable {
  var Brand: [BrandDecodable]
}

struct BrandDecodable: Decodable {
  var name: String
  var slug: String
}
