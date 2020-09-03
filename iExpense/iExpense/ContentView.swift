//
//  ContentView.swift
//  iExpense
//
//  Created by Terry on 2020/7/11.
//  Copyright © 2020 Terry. All rights reserved.
//

import SwiftUI



struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}


struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                    }
                }
            .onDelete(perform: removeItem)
            }
            .navigationBarTitle("iExpenses")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddView = true
                }) {
                     Image(systemName: "plus")
                }
            )
                .sheet(isPresented: $showingAddView) {
                    AddView(expenses: self.expenses)
            }
            //.navigationBarItems(leading: EditButton())
        }
    }
    
    func removeItem(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}
/*
struct User: Codable {
    var firstName: String
    var lastName: String
}

struct ContentView: View {
    @State private var user = User(firstName: "terry", lastName: "stephen")
    var body: some View {
        Button("Save user") {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(self.user) {
                UserDefaults.standard.set(data, forKey: "userData")
            }
        }
    }
}
*/

/*
struct ContentView: View {
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    var body: some View {
        Button("Tap \(tapCount) times") {
            self.tapCount += 1
            UserDefaults.standard.set(self.tapCount, forKey: "Tap")
        }
    }
}
*/

/*
struct ContentView: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("\($0)")
                    }
                .onDelete(perform: removeRow)
                }
                
                Button("Add Number") {
                    self.numbers.append(self.currentNumber)
                    self.currentNumber += 1
                }
            }
            .navigationBarItems(leading: EditButton())
        }
    }
    
    func removeRow(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}
*/
 
/*
struct SecondView: View {
    var name: String
    @Environment(\.presentationMode) var temp
    
    var body: some View {
        Button("Dismiss") {
            self.temp.wrappedValue.dismiss()
        }
    }
}


struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("show second view") {
            self.showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "Terry")
        }
    }
}
*/

/*
struct SecondView: View {
    var name: String
    var body: some View {
        Text("Hello \(self.name)")
    }
}


struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("show second view") {
            self.showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "Terry")
        }
    }
}
*/



/*
class User: ObservableObject {
    @Published var first_name = "Terry"
    @Published var last_name = "ritter"
}


struct ContentView: View {
    @ObservedObject var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is: \(user.first_name) \(user.last_name)")
            TextField("First Name:", text: $user.first_name)
            TextField("Last Name:", text: $user.last_name)
        }

    }
}
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
