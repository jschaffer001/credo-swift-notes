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
    
    @AppStorage("lineCount") var lineCount: Int = 1
    
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    
    // MARK: - FUNCTION
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func save() {
        // dump(notes)
        do {
            // 1. Convert the notes array to data using JSONEncoder
            let data = try JSONEncoder().encode(notes)
            
            // 2. Create a new URL to save the dile using the getDocumentDirectory
            let url = getDocumentDirectory().appendingPathComponent("notes")
            
            // 3. Write the data to the given URL
            try data.write(to: url)
            
        } catch {
            print("Saving data has failed!")
        }
    } //: SAVE
    
    func load () {
        DispatchQueue.main.async {
            do {
                // 1. Get the notes URL path
                let url = getDocumentDirectory().appendingPathComponent("notes")
                
                // 2. Create a new property for the data
                let data = try Data(contentsOf: url)
                
                // 3. DEcode the data
                notes = try JSONDecoder().decode([Note].self, from: data)
                
            } catch {
                // Do nothing
            }
        } //: DISPATCH QUEUE
    } //: LOAD
    
    func delete(offsets: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    
    // MARK: - BODY
    var body: some View {
        // Navigation needs to be done in a navigation stack now
        NavigationStack {
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
                
                if notes.count >= 1 {
                    List {
                        ForEach(0..<notes.count,id: \.self) { i in
                            NavigationLink{DetailView(note: notes[i], count: notes.count, index: i)}
                                label: {
                                    HStack {
                                       Capsule()
                                            .frame(width: 4)
                                            .foregroundColor(.accentColor)
                                        Text(notes[i].text)
                                            .lineLimit(lineCount)
                                            .padding(.leading, 5)
                                    }//: HSTACK
                            } //: NAVLINK LABEL
                        } //: LOOP
                        .onDelete(perform: delete)
                    }
                } else {
                    Spacer()
                    Image(systemName: "note.text")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .opacity(0.25)
                        .padding(25)
                    Spacer()
                } //: LIST
                
            } //: VSTACK
            //.navigationTitle("Notes")
            .onAppear(perform: {
                load()
        })
        } //: NAVSTACK
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
