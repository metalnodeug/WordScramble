//
//  ContentView.swift
//  WordScramble
//
//  Created by metalnodeug on 23/10/2019.
//  Copyright © 2019 metalnodeug. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""


    var body: some View {
        NavigationView {
            VStack{
                TextField("Enter your word", text: $newWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(usedWords, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
