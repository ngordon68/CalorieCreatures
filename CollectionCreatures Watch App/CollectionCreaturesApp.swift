//
//  CollectionCreaturesApp.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/20/23.
//

import SwiftUI

/*
 watch vibrates
 'when egg hatches
 */

@main
struct CollectionCreatures_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(eggModel: .exampleRare)
        }
    }
}
