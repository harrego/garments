//
//  CollectionDecodeable.swift
//  Vogue Runway
//
//  Created by Harry Stanton on 11/04/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Foundation

struct GetCollectionsDecodable: Decodable {
  var data: AllCollectionsDecodable
}

struct AllCollectionsDecodable: Decodable {
  var allContent: CollectionsContentArrayDecodable
}

struct CollectionsContentArrayDecodable: Decodable {
  var Content: [CollectionDecodable]
}

struct CollectionDecodable: Decodable {
  var id: String
  var date: String?
  var url: String
  var title: String
  var slug: String
  var brand: BrandDecodable
  var season: SeasonDecodable
}

struct SeasonDecodable: Decodable {
  var name: String
  var slug: String
  var year: Int
}
