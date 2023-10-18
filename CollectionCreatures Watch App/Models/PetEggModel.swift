//
//  PetEggModel.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/22/23.
//

import Foundation
import SwiftUI

enum Rarity {
    case noEgg
    case uncommon
    case rare
    case ultraRare
}

struct EggModel: Identifiable, Hashable, Equatable {
    
    var id = UUID()
    var eggTop:String = "commonEggtop"
    var eggBottom:String = "commonEggBottom"
    var wholeEgg:String = "uncommonEgg"
    var eggRarity:Rarity
    var caloriesNeeded: Int
    var currentCaloriesBanked:Int = 0
    var isCurrentlySelected: Bool = false
    
    init(id: UUID = UUID(), eggRarity: Rarity) {
        self.id = id
        self.eggRarity = eggRarity
     
        switch eggRarity {

        case .uncommon:
            self.eggTop = "commonEggTop"
            self.caloriesNeeded = 500
            self.eggBottom = "commonEggBottom"
            self.wholeEgg = "uncommonEgg"
        case .rare:
            self.caloriesNeeded = 1500
            self.wholeEgg = "rareEgg"
        case .ultraRare:
            self.caloriesNeeded = 3000
            self.wholeEgg = "ultraRareEgg"
            self.eggTop = "ultraRareEggTop"
            self.eggBottom = "ultraRareEggBottom"
            
        case .noEgg:
           // self.eggColor = ""
            self.caloriesNeeded = 2000
            
        }
    }
    
    static let exampleCommon = EggModel(eggRarity: .ultraRare)
    static let exampleUncommon = EggModel(eggRarity: .uncommon)
    static let exampleRare = EggModel(eggRarity: .rare)
    static let noEggSelected = EggModel(eggRarity: .noEgg)

}


