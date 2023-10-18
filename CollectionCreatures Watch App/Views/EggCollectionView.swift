//
//  EggCollectionView.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/22/23.
//

import SwiftUI

struct EggCollectionView: View {
    
    @ObservedObject var eggVM:EggViewModel
     var eggModel: EggModel
    
    let rows = [
        GridItem(.fixed(50), spacing: 15),
        GridItem(.fixed(50), spacing: 15),
        GridItem(.fixed(50), spacing: 15)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: rows, spacing: 5) { 
                ForEach(eggVM.listOfEggs.indices) { index in
                    let egg = eggVM.listOfEggs[index]
                    
                    VStack {
                        if egg.isCurrentlySelected {
                            Rectangle()
                                .frame(height:3)
                        }
                        Button {
                            eggVM.selectEgg(for: egg)
                            eggVM.listOfEggs[index].isCurrentlySelected.toggle()
                            
                            for item in eggVM.listOfEggs.indices {
                                eggVM.listOfEggs[item].isCurrentlySelected = (item == index)
         
                            }
                            
                        } label: {
                            Image(egg.wholeEgg)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .background( egg.isCurrentlySelected ? .orange : .black)
                        
                        if egg.isCurrentlySelected {
                            Rectangle()
                                .frame(height:3)
                        }
                    }
                }
            }
        }
    }
}

struct EggCollectionView_Previews: PreviewProvider {
    
    @ObservedObject var eggVM:EggViewModel
    
    static var previews: some View {
        EggCollectionView(eggVM: .init(), eggModel: .exampleRare)
    }
}
