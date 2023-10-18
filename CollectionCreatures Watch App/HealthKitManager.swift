//
//  HealthKitManager.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/20/23.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    @Published var mostRecentDateFetched:Date = Date()
    
    @Published var currentCalories: Int = 0
    @Published var storedCalorites: Int = 0
    @Published var calorieBank: Int = 0
    
    @Published var testcurrentCalories: Double = 0.000
    @Published var teststoredCalorites: Double = 0.000
    @Published var testcalorieBank: Double = 0
    
    var caloriesDifferent:Double = 0.00000000
    
    func subtractCalories(eggModel: EggModel) {
        
        
        currentCalories -= eggModel.caloriesNeeded
    }
    
    init() {
        
        let energy = HKQuantityType(.basalEnergyBurned)
        let healthTypes: Set = [energy]

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodayCaloriess()
            } catch {
                print("error fetching health data")
            }
            
        }
    }

    func calculatorCalorieBank() {
        var calorieDifference = currentCalories - storedCalorites
        
         calorieBank = calorieDifference + storedCalorites
        
        storedCalorites = currentCalories
    }
    
    func fetchTodayCaloriess() {
        let caloriesType = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let calendar = Calendar.current
        let now = Date()
       // let startOfDay = calendar.startOfDay(for: .startOfDay)
        let oneHourAgo = calendar.date(byAdding: .minute, value: -30, to: now)
       
        let predicate = HKQuery.predicateForSamples(withStart: oneHourAgo, end: now)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: caloriesType,
            quantitySamplePredicate: predicate,
            options: [.cumulativeSum],
            anchorDate: oneHourAgo!,
            intervalComponents: DateComponents(second: 1) //was hour
        )
        
        query.initialResultsHandler = { query, results, error in
            guard let statistics = results else {
                if let error = error {
                    print("Error fetching calories data: \(error.localizedDescription)")
                }
                return
            }
            
            var totalCaloriesBurned = 0.0
            
            statistics.enumerateStatistics(from: oneHourAgo!, to: now ) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    totalCaloriesBurned += sum.doubleValue(for: HKUnit.largeCalorie())
                   
                }
            }
            //save to storage here
            
            DispatchQueue.main.async {
                self.currentCalories = Int(totalCaloriesBurned)
                self.testcurrentCalories = totalCaloriesBurned
               // self.calculatorCalorieBank()
               // self.mostRecentDateFetched = now
               
               // print("\(totalCaloriesBurned) from healthkit")
                
                
                self.caloriesDifferent = Double(self.teststoredCalorites) - Double(self.testcurrentCalories)
                print(" stored calories: \(self.teststoredCalorites)")
                print(" current calories: \(self.testcurrentCalories)")
                print("\(self.caloriesDifferent)")
                
                
                
                self.testcalorieBank += abs(self.caloriesDifferent)
                
                print("bank:\(self.testcalorieBank) ")
                DispatchQueue.main.asyncAfterUnsafe(deadline: .now() + 1) {
                 
    //
                    self.teststoredCalorites = self.testcurrentCalories
                }
                
              
                
               // self.calculatorCalorieBank()
               
            }
        }
        
        healthStore.execute(query)
    }
    
//    func enableBackGroundDelivery() {
//       
//        healthStore.enableBackgroundDelivery(for: .activitySummaryType(), frequency: .immediate) { <#Bool#>, <#Error?#> in
//            <#code#>
//        }
//    }

}

extension Date {
    
    static var startOfDay:Date {
        
        Calendar.current.startOfDay(for: Date())
    }
    
//    static var currentDateinTime:Date {
//        Calendar.current.startOfDay(for: .now)
//    }
}


/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
//
//
//import Foundation
//import HealthKit
//
//class WorkoutManager: NSObject, ObservableObject {
//    var selectedWorkout: HKWorkoutActivityType? {
//        didSet {
//            guard let selectedWorkout = selectedWorkout else { return }
//            startWorkout(workoutType: selectedWorkout)
//        }
//    }
//
//    @Published var showingSummaryView: Bool = false {
//        didSet {
//            if showingSummaryView == false {
//                resetWorkout()
//            }
//        }
//    }
//
//    let healthStore = HKHealthStore()
//    var session: HKWorkoutSession?
//    var builder: HKLiveWorkoutBuilder?
//
//    // Start the workout.
//    func startWorkout(workoutType: HKWorkoutActivityType) {
//        let configuration = HKWorkoutConfiguration()
//        configuration.activityType = workoutType
//        configuration.locationType = .unknown
//
//        // Create the session and obtain the workout builder.
//        do {
//            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
//            builder = session?.associatedWorkoutBuilder()
//        } catch {
//            // Handle any exceptions.
//            return
//        }
//
//        // Setup session and builder.
//        session?.delegate = self
//        builder?.delegate = self
//
//        // Set the workout builder's data source.
//        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
//                                                     workoutConfiguration: configuration)
//
//        // Start the workout session and begin data collection.
//        let startDate = Date()
//        session?.startActivity(with: startDate)
//        builder?.beginCollection(withStart: startDate) { (success, error) in
//            // The workout has started.
//        }
//    }
//
//    // Request authorization to access HealthKit.
//    func requestAuthorization() {
//        // The quantity type to write to the health store.
//        let typesToShare: Set = [
//            HKQuantityType.workoutType()
//        ]
//
//        // The quantity types to read from the health store.
//        let typesToRead: Set = [
//            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
//            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
//            HKObjectType.activitySummaryType()
//        ]
//
//        // Request authorization for those quantity types.
//        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
//            // Handle error.
//        }
//    }
//
//    // MARK: - Session State Control
//
//    // The app's workout state.
//    @Published var running = false
//
//    func togglePause() {
//        if running == true {
//            self.pause()
//        } else {
//            resume()
//        }
//    }
//
//    func pause() {
//        session?.pause()
//    }
//
//    func resume() {
//        session?.resume()
//    }
//
//    func endWorkout() {
//        session?.end()
//        showingSummaryView = true
//    }
//
//    // MARK: - Workout Metrics
//    @Published var averageHeartRate: Double = 0
//    @Published var heartRate: Double = 0
//    @Published var activeEnergy: Double = 0
//    @Published var distance: Double = 0
//    @Published var workout: HKWorkout?
//
//    func updateForStatistics(_ statistics: HKStatistics?) {
//        guard let statistics = statistics else { return }
//
//        DispatchQueue.main.async {
//            switch statistics.quantityType {
//            case HKQuantityType.quantityType(forIdentifier: .heartRate):
//                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
//                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
//                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
//            case HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned):
//                let energyUnit = HKUnit.kilocalorie()
//                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
//            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
//                let meterUnit = HKUnit.meter()
//                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
//            default:
//                return
//            }
//        }
//    }
//
//    func resetWorkout() {
//        selectedWorkout = nil
//        builder = nil
//        workout = nil
//        session = nil
//        activeEnergy = 0
//        averageHeartRate = 0
//        heartRate = 0
//        distance = 0
//    }
//}
//
//// MARK: - HKWorkoutSessionDelegate
//extension WorkoutManager: HKWorkoutSessionDelegate {
//    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
//                        from fromState: HKWorkoutSessionState, date: Date) {
//        DispatchQueue.main.async {
//            self.running = toState == .running
//        }
//
//        // Wait for the session to transition states before ending the builder.
//        if toState == .ended {
//            builder?.endCollection(withEnd: date) { (success, error) in
//                self.builder?.finishWorkout { (workout, error) in
//                    DispatchQueue.main.async {
//                        self.workout = workout
//                    }
//                }
//            }
//        }
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//
//    }
//}
//
//// MARK: - HKLiveWorkoutBuilderDelegate
//extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
//    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//
//    }
//
//    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
//        for type in collectedTypes {
//            guard let quantityType = type as? HKQuantityType else {
//                return // Nothing to do.
//            }
//
//            let statistics = workoutBuilder.statistics(for: quantityType)
//
//            // Update the published values.
//            updateForStatistics(statistics)
//        }
//    }
//}
 */
