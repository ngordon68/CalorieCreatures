//
//  EggViewModel.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/22/23.
//

import SwiftUI
import Foundation

class EggViewModel: ObservableObject {
    
    @Published var currentEgg: EggModel = .exampleUncommon
    @Published var currentPetImage: PetModel = .init(id: UUID(), icon: .uncommon)
    @Published var isHatching = false
    @Published var didMeetCalorieGoal = false
    
    init() {
        scheduleDailyTask()
    }

    @Published var listOfEggs:[EggModel] =
    [
    EggModel(eggRarity: .uncommon),
    EggModel(eggRarity: .rare),
    EggModel(eggRarity: .ultraRare),
    EggModel(eggRarity: .ultraRare)

    ]
    
    @Published var hatchedPets:[PetModel] = [

    ]
    
    var eggRates:[EggModel] = []
    
   func selectEgg(for eggModel:EggModel) {
        currentEgg = eggModel

    }

    
    func productRandomEgg() {
       // if self.listOfEggs.count < 6 {
            for _ in 1...55 {
                eggRates.append( EggModel(eggRarity: .uncommon))
            }
            
            for _ in 1...40 {
                eggRates.append( EggModel(eggRarity: .rare))
            }
            
            for _ in 1...5 {
                eggRates.append( EggModel(eggRarity: .ultraRare))
            }
            print(eggRates.count)
            
            if let newEgg = eggRates.randomElement() {
                listOfEggs.append(newEgg)
                print(newEgg.eggRarity)
            }
            
            eggRates.removeAll()
        }
   // }

    func hatchEgg(currentEgg:EggModel) {
        let newPet = PetModel(id: currentEgg.id, icon: currentEgg.eggRarity)
        currentPetImage = newPet
        hatchedPets.append(newPet)
        listOfEggs.removeAll { $0.id == currentEgg.id }
        
    }
    
    func scheduleDailyTask() {
        // Create a Calendar instance
        let calendar = Calendar.current

        // Get the current date and time
        let now = Date()

        // Calculate the date for the next day at the same time
        if let nextDay = calendar.date(byAdding: .minute, value: 1, to: now) {

            // Calculate the time interval until the next day
            let timeInterval = nextDay.timeIntervalSinceNow

            // Create a timer that fires once a day
            let timer = Timer(timeInterval: timeInterval, repeats: true) { _ in
                self.productRandomEgg()
            }

            // Add the timer to the main run loop
            RunLoop.main.add(timer, forMode: .common)
            
            print("egg schedule started")
        }
        
    }

}



