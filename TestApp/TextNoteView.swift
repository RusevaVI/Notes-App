import SwiftUI

struct TextNoteView: View {
    @State var note: Note
    var onSave: (Note) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {

            
            TextField("Новая заметка", text: $note.title)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            
            ZStack(alignment: .topLeading) {
                if note.text.isEmpty {
                    Text("Введите текст...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                }

                TextEditor(text: $note.text)
                    .padding(8)
                    .scrollContentBackground(.hidden)
            }
            .frame(minHeight: 150)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3))
            )
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .onDisappear {
            onSave(note)
        }
    }
}
