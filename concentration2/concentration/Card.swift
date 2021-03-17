//
//  Card.swift
//  concentration
//
//  Created by ChuckLiu on 24/02/21.
//

import Foundation

struct Card : Hashable
{
    func hash(into hasher: inout Hasher){
        hasher.combine(identifier)
    }
    static func == (lhs: Card, rhs: Card)-> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
  private  var identifier : Int
    
    static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
