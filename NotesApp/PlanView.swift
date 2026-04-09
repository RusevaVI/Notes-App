import SwiftUI

struct PlanView: View {
    @State var note: Note
    var onSave: (Note) -> Void

    @State private var selectedDate: Date
    @State private var text: String

    init(note: Note, onSave: @escaping (Note) -> Void) {
        self._note = State(initialValue: note)
        self.onSave = onSave
        self._selectedDate = State(initialValue: note.plan?.date ?? Date())
        self._text = State(initialValue: note.plan?.text ?? "")
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("Заголовок", text: $note.title)
                .font(.title)
                .padding(.bottom, 20)

            DatePicker(
                "Дата события",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Описание")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                }

                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(4)
            }
            .frame(minHeight: 80)

            Spacer()

            Text(selectedDate.formatted(date: .long, time: .shortened))
        }
        .padding()
        .onDisappear {
            note.plan = Plan(text: text, date: selectedDate)
            onSave(note)
        }
    }
}
