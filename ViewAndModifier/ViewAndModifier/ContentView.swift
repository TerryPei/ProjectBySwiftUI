//
//  ContentView.swift
//  ViewAndModifier
//
//  Created by Terry on 2020/6/30.
//  Copyright © 2020 Terry. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        Text("Terry")
        .blueTitleModifier()
        /*
            GridStack(rows: 6, columns: 2) { row, col in
                Image(systemName: "\(4 * row + col).circle")
                Text("R\(row), C\(col)")
         */
    }
}



// Title and WaterMark are my custom modifiers
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.purple)
            .clipShape(RoundedRectangle(cornerRadius:10))
    }
}


extension View {
    func titleStyleModifier() -> some View {
        self.modifier(Title())
    }
}

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
            .background(Color.yellow)
    }
}

extension View {
    func blueTitleModifier() -> some View {
        self.modifier(BlueTitle())
    }
}

struct WaterMark: ViewModifier {
    var text: String
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}

extension View {
    func WaterMarkModifier (with text: String) -> some View {
        self.modifier(WaterMark(text: text))
    }
}

//GridStack is my custom container.
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(spacing: 40) {
            ForEach(0 ..< self.rows, id: \.self) { row in
                HStack(spacing: 40) {
                    ForEach(0 ..< self.columns, id: \.self) { col in
                        self.content(row, col)
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


