import SwiftUI

struct PlanView: View {
    
    var note: Note
    var onSave: (Note) -> Void
    
    @State private var selectedDate: Date
    @State var title = "Календарь"
    @State var text: String
    
    @Environment(\.dismiss) var dismiss
    
    init(note: Note, onSave: @escaping (Note) -> Void) {
        self.note = note
        self.onSave = onSave
        _title = State(initialValue: note.title)
        _text = State(initialValue: note.plan?.text ?? "")
        _selectedDate = State(initialValue: note.plan?.date ?? Date())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            
            TextField("Заголовок", text: $title)
                .font(.title)
                .padding(.bottom,20)
            
            
            Section {
                DatePicker(
                    "Дата события",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .foregroundStyle(.blue)
                .datePickerStyle(.automatic)
            }
            Divider()
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                .padding(.vertical, 8)
            ZStack(alignment: .topLeading) {
                
                if text.isEmpty {
                    Text("Описание")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .font(.system(size: 20))
                }
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(4)
            }
            .frame(minHeight: 80)
            
            Spacer()
            
            Section {
                Text("Вы выбрали:")
                Text("\(selectedDate.formatted(date: .long, time: .shortened))")
                    .font(.headline)
            }
        }
        .padding()
        
        .onDisappear {
            var updated = note
            updated.title = title
            updated.plan = Plan(text: text, date: selectedDate)
            onSave(updated)
        }
        
    }
}
