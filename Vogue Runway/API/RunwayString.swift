//
//  RunwayString.swift
//  Vogue Runway
//
//  Created by Harry Stanton on 11/04/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Foundation

class RunwayStrings {
  private func htmlEncode(string: String) -> String {
    return string.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
  }
  
  public var graphURL = "https://graphql.vogue.com/graphql?query="
  
  public func getBrands() -> String {
    return htmlEncode(string: "query { allBrands { Brand { name slug } }}")
  }
  
  public func listCollections(slug: String) -> String {
    return htmlEncode(string: "query { allContent(type: [\"FashionShowV2\"], first: 25, filter: { brand: { slug: \"\(slug)\" } }) { Content { id GMTPubDate url title slug _cursor_ ... on FashionShowV2 { instantShow brand { name slug } season { name slug year } photosTout { ... on Image { url } } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } } }")
  }
}
