//
//  PetModel.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/26/23.
//

import Foundation


struct PetModel:Identifiable {
    
    var id:UUID
    var icon:Rarity
    var petImage:String

    init( id: UUID, icon:Rarity) {
        self.id = id
        self.icon = icon
        
        switch icon {
            
        case .uncommon:
            
            self.petImage = "sloth"
            
        case .rare:
            self.petImage = "snake"
            
        case.ultraRare:
           // if let petImage = ultraRarePets.randomElement() {
            self.petImage = ultraRarePets.randomElement() ?? ""
           // }
            
        case .noEgg:
            self.petImage = "unicorn"
        }
    }
}




var ultraRarePets:[String] = [
     
    "sloth",
    "dragon",
    "unicorn",
    "turtle",
    "snake"
]
