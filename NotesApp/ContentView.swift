import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var editingNote: Note? = nil
    @State private var drawingNote: Note? = nil
    @State private var planingNote: Note? = nil
    @State private var shoppingNote: Note? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Button("Добавить заметку") {
                    let newNote = Note(title: "Новая заметка")
                    notes.append(newNote)
                    editingNote = newNote
                }
                .padding()
                List {
                    ForEach(notes) { note in
                        HStack {
                            
                            Text(note.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            if let plan = note.plan {
                                Text(plan.date.formatted(date: .numeric, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if note.isDrawing {
                                drawingNote = note
                            } else if note.plan != nil {
                                planingNote = note
                            } else if note.isShopping {
                                shoppingNote = note
                            } else {
                                editingNote = note
                            }
                        }
                        
                    }
                    
                    .onDelete { indexSet in
                        notes.remove(atOffsets: indexSet)
                    }
                    
                }
                .listStyle(.plain)
                .navigationTitle("Заметки")
                .overlay(
                    Menu {
                        Button("Список") {
                            shoppingNote = Note(title: "Список покупок",isShopping: true)
                        }
                        Button("Рисовать") {
                            drawingNote = Note(title: "Рисунок", isDrawing: true)
                        }
                        
                        Button ("Календарь") {
                            planingNote = Note(title: "Новое событие")
                        }
    
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.largeTitle)
                    }.padding(), alignment: .bottomTrailing
                )
            }
            
            
            .navigationDestination(item: $shoppingNote) { note in
                ShoppingListView (note: note) { updatedNote in
                    
                    let trimmedTitle = updatedNote.title.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedTitle.isEmpty else { return }
                    
                    var finalNote = updatedNote
                    finalNote.title = trimmedTitle
                    finalNote.isShopping = true
                    
                    if let index = notes.firstIndex(where: { $0.id == finalNote.id }) {
                        notes[index] = finalNote
                        
                    } else {
                        notes.append(finalNote)
                    }
                }
            }
            
            
            .navigationDestination(item: $drawingNote) { note in
                DrawingView(note: note) { updatedNote in
                    
                    if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
                        notes[index] = updatedNote
                    } else {
                        notes.append(updatedNote)
                    }
                }
            }
            
            .navigationDestination(item: $planingNote) { note in
                PlanView(note: note) { updatedNote in
                    
                    if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
                        notes[index] = updatedNote
                    } else {
                        notes.append(updatedNote)
                    }
                }
            }
            
            .navigationDestination(item: $editingNote) { note in
                TextNoteView(note: note) { updatedNote in
                    if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
                        notes[index] = updatedNote
                    } else {
                        notes.append(updatedNote)
                    }
                }
            }
            
        }
    }
}
