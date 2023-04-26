// ContentView.swift
// Notes
// 
// Created by Jonathan Schaffer
// Using Swift 5.0
//
// https://jonathanschaffer.com
// Copyright © 2023 Jonathan Schaffer. All rights reserved.

import SwiftUI

struct ContentView: View {
    // MARK: - PRPERTY
    
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    
    // MARK: - FUNCTION
    func save() {
        dump(notes)
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 6) {
                TextField("Add New Note", text: $text)
                
                Button {
                    // 1. Only run the button's action when the text field is not empty
                    guard text.isEmpty == false else { return }
                    
                    // 2. Create a new note item and initialize it with the text value
                    let note = Note(id: UUID(), text: text)
                    
                    // 3. Add the new note item to the notes array (append)
                    notes.append(note)
                    
                    // 4. Make the text field empty
                    text = ""
                    
                    // 5. Save the notes (function)
                    save()
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                }
                .fixedSize()
                //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.accentColor)
            } //: HSTACK
            
            Spacer()
            
            Text("\(notes.count)")
            
        } //: VSTACK
        .navigationTitle("Notes")
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
