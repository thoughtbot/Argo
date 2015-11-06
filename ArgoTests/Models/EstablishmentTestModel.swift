//
//  EstablishmentTestModel.swift
//  Argo
//
//  Created by David on 05/11/2015.
//  Copyright © 2015 thoughtbot. All rights reserved.
//

import Foundation
import Argo
import Curry

struct Establishment {
  let id: Int
  let fhrsid: Int
  let name: String?
  let address: String?
  let postcode: String?
  let rating: Int
  let ratingDate: String?
  let latitude: Float?
  let longitude: Float?
  let createdDate: String
  let updatedDate: String
  let validated: Bool
}

extension Establishment: Decodable {
    static func decode(j: JSON) -> Decoded<Establishment> {
        let f = curry(self.init)
        return f
            <^> j <| "id"
            <*> j <| "fhrsid"
            <*> j <|? "name"
            <*> j <|? "address"
            <*> j <|? "postcode"
            <*> j <| "rating"
            <*> j <|? "rating_date"
            <*> j <|? "lat"
            <*> j <|? "long"
            <*> j <| "created_at"
            <*> j <| "updated_at"
            <*> j <| "validated"
    }
}
