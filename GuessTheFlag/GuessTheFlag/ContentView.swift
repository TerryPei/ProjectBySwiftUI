//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Terry on 2020/6/29.
//  Copyright © 2020 Terry. All rights reserved.
//





import SwiftUI

struct ContentView: View {
    @State private var counties = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingTitle = ""
    @State private var showingScore = false
    
    @State private var score = 0
    
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var offset = CGSize.zero
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                //return a VStack View
                VStack(spacing: 30) {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(counties[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                //return a ForEach View
                ForEach (0 ..< 3) { number in
                    
                    Button(action: {
                        //Tap the button, cause the showingScore became true, to active .alert
                        self.showScore(number)
                    }) {
                        Image(self.counties[number])
                            .flagImage()
                    }
                    .rotation3DEffect(number == self.correctAnswer ? .degrees(self.animationAmount): .degrees(0), axis: (x: 0, y: 1, z: 0))
                    .opacity(number != self.correctAnswer ? self.opacity : 1)
                    
                }
                
                Spacer()
                //return a Section view
                Section (header: Text("Total score")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)) {
                    Text("\(self.score)")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(showingTitle), message: Text("Your score is \(self.score)"), dismissButton: .default(Text("continue")) {
                self.animationAmount = 0.0
                self.opacity = 1.0
                self.offset = CGSize.zero
                self.askQuestion()
                })
    }
        
    }
    
    
    func showScore(_ number: Int) {
        if (number == correctAnswer) {
            showingTitle = "Your answer is correct."
            self.score += 1
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                self.animationAmount += 360
            }
        } else {
            showingTitle = "Wrong! The flag you choose is \(counties[number])"
            self.offset = CGSize(width: 10, height: 0)
            withAnimation(.interpolatingSpring(stiffness: 2000, damping: 10)) {
                self.offset = .zero
            }
        }
        withAnimation(.easeOut) {
            self.opacity = 0.25
        }
        showingScore = true
    }

    func askQuestion() {
        counties.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}



extension Image {
    func flagImage() -> some View {
        self
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

