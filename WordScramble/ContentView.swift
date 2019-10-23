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
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false


    var body: some View {
        NavigationView {
            VStack{
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()

                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
            }
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard answer.count > 0 else {
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }

        usedWords.insert(answer, at: 0)
        newWord = ""
    }

    ///Starting game with start.txt file containing all word to the game.
    func startGame() {
        guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            return

        }

        if let startWords = try? String(contentsOf: startWordsURL) {
            let allWords = startWords.components(separatedBy: "\n")

            rootWord = allWords.randomElement() ?? "silkworm"
            return
        }

        fatalError("Could not load start.txt from bundle.")
    }


    ///Check if the word is original.
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    ///Check if the word is possible, this method check each letter in the orignal word and delete each letter after he found an mirror. If all letter are in the word, the func return true, else he return false
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }

    /// Using Objec-c UITextChecker to check if the word exist.
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }

    /// Just create an error to display in .alert
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
