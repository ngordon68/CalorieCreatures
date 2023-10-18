//
//  PetCollection.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/26/23.
//

import SwiftUI

struct PetCollectionView: View {
    @ObservedObject var petVM:EggViewModel
    
    let rows = [
        GridItem(.fixed(50), spacing: 15),
        GridItem(.fixed(50), spacing: 15),
        GridItem(.fixed(50), spacing: 15)
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: rows, spacing: 5) {
                ForEach(petVM.hatchedPets) { pet in
                    Image(pet.petImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                
                }
            }
        }
    }
}

struct PetCollection_Previews: PreviewProvider {
    static var previews: some View {
        PetCollectionView(petVM: .init() )
    }
}
