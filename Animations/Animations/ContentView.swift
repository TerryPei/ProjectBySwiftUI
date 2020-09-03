//
//  ContentView.swift
//  Animations
//
//  Created by Terry on 2020/7/8.
//  Copyright © 2020 Terry. All rights reserved.
//
//
/*
Three ways to deisign animation:
 1. attach to a View
 2. attach to a binding value
 3. explicitly asking for a particular animation to occur because of a state change.
 */

import SwiftUI


//Building custom transitions using ViewModifier
struct CornorRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
        .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornorRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornorRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
    
}



//Showing and hiding views with transitions

struct ContentView: View {
    @State private var showingRed = false
    var body: some View {
        VStack {
            Button("Tap me") {
                withAnimation {
                    self.showingRed.toggle()
                }
            }
            if showingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    //.transition(.scale)
                    //.transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .transition(.pivot)
            }

        }
    }
}



//animation gestures
/*
struct ContentView: View {
    let letters = Array("Terry, Ritter")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<self.letters.count) { num in
                Text(String(self.letters[num]))
                .padding(5)
                    .font(.title)
                    .background(self.enabled ? Color.orange : Color.blue)
                    .offset(self.dragAmount)
                    .animation(Animation.default.delay(Double(num) / 20))
                    //.foregroundColor(.white
            }
        }
    .gesture(
        DragGesture()
            .onChanged { self.dragAmount = $0.translation }
            .onEnded { _ in
                self.dragAmount = .zero
                self.enabled.toggle()
        }
    )
        
    }
}
*/
/*
struct ContentView: View {
    @State private var dragAmount = CGSize.zero
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged {self.dragAmount = $0.translation}
                .onEnded { _ in
                    withAnimation(.spring()) {
                        self.dragAmount = .zero}
                    }
        )
        //.animation(.spring())
    }
}
*/





// animation order  matters
/*
struct ContentView: View {
    @State private var enabled = true
    var body: some View {
        Button("Tap me") {
            //do nothing
            self.enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? Color.red: Color.blue)
        .animation(nil)
        .foregroundColor(.white)
        .animation(.default)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1))
    }
}
*/

//explicitly withAnimation(Animation) {}
/*
struct ContentView: View {
    @State private var animationAmount = 0.0
    var body: some View {
        Button("Tap me") {
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                self.animationAmount += 360
            }
        }
    .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
    .clipShape(Circle())
      .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 0, z: 0))
    }
}
*/

//attach to a binding value
/*
struct ContentView: View {
    @State private var animationAmount: CGFloat = 1
    var body: some View {
        print(animationAmount)
        
        return VStack {
            
            Stepper("Scale amount", value: $animationAmount.animation(
                Animation.easeInOut(duration: 1).repeatCount(3)
            ), in: 1...10)
            
            Spacer()
            
            Button("Tap me") {
                    self.animationAmount += 1
            }
        .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        }
    }
}
*/


//attach to a View
/*
struct ContentView: View {
    @State private var animationamount: CGFloat = 1
    var body: some View {
        Button("Tap Me") {
            // do nothing
            //self.animationamount += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.blue)
                .scaleEffect(animationamount)
            //.opacity(Double(2-animationamount))
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
        ).onAppear {
            self.animationamount = 2
        }
        //.scaleEffect(animationamount)
        //.animation(Animation.easeInOut(duration: 0.6).repeatCount(6, autoreverses: true))
    
        //.animation(.interpolatingSpring(stiffness: 60, damping: 1))
        
        //.animation(.easeOut)
        
    }
}
*/

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
