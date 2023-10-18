//
//  ContentView.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 9/20/23.
//

/*
  when user open app to check egg. hidden workout starts to actively track calories
  when app times out, the calories get added to total calories for display
  */
import SwiftUI

struct ContentView: View {
    
    @StateObject var healthManager = HealthManager()
    @StateObject var eggVM = EggViewModel()
    @State var eggModel: EggModel

    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let eggTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   let checkIfGoalReachedStatus = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
   @State  var hatchingTime = 0
   var animateEggRocking: Animation = Animation.linear(duration: 1).repeatForever(autoreverses: true)
    
    @State var animationEggState = false
    @State var isCrackingEgg = false
    @State var isChangingFromEggToPet = false
    @State var isShowingPetView = false
    @State var isShowingOpacity = false
    
    func checkIfGoalReached() {
       if healthManager.currentCalories >= eggVM.currentEgg.caloriesNeeded {
           eggVM.didMeetCalorieGoal = true
//           NotificationManager.instance.scheduleNotification()
        }
    }
    
    func increaseCalories() {
        healthManager.currentCalories += 500
    }
    
    var body: some View {
        
        if isShowingPetView == true {
                hatchedEgg
        }

        if eggVM.isHatching == true {
            VStack {
      
               crackedEgg
                 
            }
            .onAppear(perform: {
                hatchingTime = 0
                isCrackingEgg = true
            })
                .onReceive(eggTimer) { _ in
                        hatchingTime += 1
                    if hatchingTime == 1 {
                        isChangingFromEggToPet = true
                    }
                     if hatchingTime == 5 {
                        eggVM.isHatching = false
                        isShowingPetView = true
//                         isCrackingEgg = false
//                         isChangingFromEggToPet = false
                      
                    }
//                            //self.eggTimer.upstream.connect().cancel()
//
                    }
        }
        
        if eggVM.isHatching == false && isShowingPetView == false {
            
            NavigationStack {
                mainScreen
            .padding()
            .onAppear {
                withAnimation(animateEggRocking) {
                    animationEggState.toggle()
                }
                
                NotificationManager.instance.requestAuthorization()
            }
            .onReceive(timer) { _ in
                healthManager.fetchTodayCaloriess()
//                healthManager.calorieBank = healthManager.currentCalories
            }
                
            .onReceive(checkIfGoalReachedStatus, perform: { _ in
                checkIfGoalReached()
            })
                
            .onChange(of: eggVM.didMeetCalorieGoal) {
                if eggVM.didMeetCalorieGoal == true {
                    NotificationManager.instance.scheduleNotification()
                    
                }
            }
            
        }
    } 
        
    }
    
    var mainScreen: some View {
        VStack {
            HStack {
                
                NavigationLink {
                    EggCollectionView(eggVM: eggVM, eggModel: eggModel)
                } label: {
                    Text("Eggs")
                        .frame(width: 50, height: 20)
                        .foregroundColor(.black)
                        .bold()
                    
                    
                }
                .frame(width: 50, height: 20)
                .cornerRadius(15)
                
                .background(
                    Rectangle()
                        .frame(width: 50, height: 20)
                        .cornerRadius(15)
                )
                
             //   Spacer()
                
                Button(action: {
                    
                    increaseCalories()
                }, label: {
                    Text("Test")
                        .frame(width: 50, height: 20)
                        .foregroundColor(.black)
                        .bold()
                })
                .frame(width: 50, height: 20)
                .cornerRadius(15)
                .background(
                    Rectangle()
                        .frame(width: 50, height: 20)
                        .cornerRadius(15)
                )
            
                Text("\(eggVM.listOfEggs.count)")
                NavigationLink {
                    PetCollectionView(petVM: eggVM)
                } label: {
                    Text("Pets")
                        .frame(width: 50, height: 20)
                        .foregroundColor(.black)
                        .bold()
                    
                    
                }
                .frame(width: 50, height: 20)
                .cornerRadius(15)
                
                .background(
                    Rectangle()
                        .frame(width: 50, height: 20)
                        .cornerRadius(15)
                )  }
            

            Image(eggVM.currentEgg.wholeEgg)
                            .resizable()
                            .scaledToFit()
                           .rotationEffect(.degrees(animationEggState ? 0 : 10), anchor: .bottom)
                        .scaleEffect(1.2)
            
     //
             
            
            Text("\(Int(healthManager.testcalorieBank)) / \(eggVM.currentEgg.caloriesNeeded) Kcal")
            
            ProgressView(value: Double(healthManager.currentCalories), total: Double(eggVM.currentEgg.caloriesNeeded))
                .animation(.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: healthManager.currentCalories)
            
            Button {
                
                checkIfGoalReached()
                if eggVM.didMeetCalorieGoal == true {
                    
                    eggVM.isHatching = true
                    eggVM.hatchEgg(currentEgg: eggVM.currentEgg)
                    healthManager.subtractCalories(eggModel: eggVM.currentEgg)
                    
                    eggVM.didMeetCalorieGoal = false
                    
                   // eggVM.didMeetCalorieGoal = false
                    
                }
                    
               // }
            } label: {
                Text("Hatch")
                    .bold()
            }
            .foregroundStyle(eggVM.didMeetCalorieGoal ? .yellow : .gray.opacity(0.2))
            
      
        }
    }
    var hatchedEgg: some View {
        
        VStack {
           
            Text("You Hatched!")
            
            Image(eggVM.currentPetImage.petImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Button {
                isShowingPetView = false
                eggVM.isHatching = false
                isCrackingEgg = false
                isChangingFromEggToPet = false
                eggVM.didMeetCalorieGoal = false
                    
            } label: {
                Text("Add to Collection")
            }
            
        }
    }
    
    var crackedEgg: some View {
        ZStack {
            
            Circle()
                .foregroundStyle(.yellow)
                .frame(width: 20)
                .scaleEffect( isChangingFromEggToPet ? 30 : 1)
                .offset(y: isCrackingEgg ? -13 : 20)
                .animation(.easeIn(duration: 3).delay(1.5), value: isCrackingEgg)
                .animation(.easeIn(duration: 1).delay(3), value: isChangingFromEggToPet)
            
            VStack {
                
                Image(eggVM.currentEgg.eggTop)
                    .resizable()
                    .aspectRatio(/*@START_MENU_TOKEN@*/1.5/*@END_MENU_TOKEN@*/, contentMode: .fit)
                    .offset(y : isCrackingEgg ? -23 : 20)
                    .offset(x : isCrackingEgg ? 20 : 0)
                    .rotationEffect(Angle(degrees: isCrackingEgg ? 50 : 0))
                
                Image(eggVM.currentEgg.eggBottom)
                    .resizable()
                    .aspectRatio(1.5, contentMode: .fit)

            }
            .animation(.easeIn(duration: 1).delay(1), value: isCrackingEgg)
            
            
            Circle()
                .foregroundStyle(.yellow)
                .frame(width: 20)
                .scaleEffect( isChangingFromEggToPet ? 30 : 1)
                .offset(y: isCrackingEgg ? -13 : 20)
                .opacity(isCrackingEgg ? 1 : 0)
                .animation(.easeIn(duration: 3).delay(1.5), value: isCrackingEgg)
                .animation(.easeIn(duration: 1).delay(3), value: isChangingFromEggToPet)
        }
    }
    
    
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(eggModel: .exampleUncommon)
    }
}
























 
 
 
 
 
 
 
 
 
 

