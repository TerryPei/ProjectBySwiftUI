//
//  ContentView.swift
//  BetterRest
//
//  Created by Terry on 2020/7/1.
//  Copyright © 2020 Terry. All rights reserved.
//

import SwiftUI





struct ContentView: View {
    
    //@State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    
    var body: some View {
        NavigationView {
            Form {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours.")
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }

            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: {
                    self.calculateBedtime()
                }) {
                    Text("Calculate")
                }
            )
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        }
        
        func calculateBedtime() {
            let model = SleepCalculator()
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            do {
                let prediction = try
                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
                
                let sleepTime = wakeUp - prediction.actualSleep
                
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                
                alertTitle = "Your ideal sleep time is..."
                alertMessage = formatter.string(from: sleepTime)
                
            } catch {
                alertTitle = "Error"
                alertMessage = "Sorry, there was a problem calculating your bedtime."
            }
            
            showingAlert = true
        }
    
}








/*
struct ContentView: View {
    @State private var sleepAmount = 8.0
    
    var body: some View {
        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
            Text("sleep hours is \(sleepAmount, specifier: "%.2f")")
        }
    }
}
*/

/*
struct ContentView: View {
    @State private var wakeUp = Date()
    
    var body: some View {
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        return DatePicker("Please enter a date", selection: components, displayedComponents: .hourAndMinute).labelsHidden
        Form {
            DatePicker("Choose Date:", selection: $wakeUp, displayedComponents: .hourAndMinute)
            
            DatePicker("Future Date:", selection: $wakeUp, in: Date()...)
        }

    }
}
*/

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
