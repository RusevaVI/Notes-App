import SwiftUI

struct DrawingView: View {

    var note: Note
    var onSave: (Note) -> Void

    enum PaperStyle: String, CaseIterable {
        case blank = "Пустой"
        case grid = "Клетка"
        case lines = "Линейка"
    }

    @State private var lines: [[CGPoint]]
    @State private var currentLine: [CGPoint] = []
    @State private var style: PaperStyle
    @State private var title: String

    @Environment(\.dismiss) var dismiss

    let canvasSize = CGSize(width: 2000, height: 2000)

    init(note: Note, onSave: @escaping (Note) -> Void) {
        self.note = note
        self.onSave = onSave
        _title = State(initialValue: note.title)
        _lines = State(initialValue: note.drawing)
        _style = State(initialValue: note.paperStyle)
    }

    var body: some View {
        VStack {
            TextField("", text: $title)
                .font(.title)
                .padding(.leading, 10)

            Picker("Стиль", selection: $style) {
                ForEach(PaperStyle.allCases, id: \.self) { s in
                    Text(s.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            
            ScrollView([.horizontal], showsIndicators: true) {
                
                ScrollView([.vertical], showsIndicators: true) {
                    ZStack {
                        PaperBackground(style: style)
                            .frame(width: canvasSize.width, height: canvasSize.height)

                        
                        ForEach(lines.indices, id: \.self) { i in
                            Path { path in
                                let line = lines[i]
                                guard let first = line.first else { return }
                                path.move(to: first)
                                for point in line.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                            .stroke(Color.black, lineWidth: 2)
                        }

                        
                        Path { path in
                            guard let first = currentLine.first else { return }
                            path.move(to: first)
                            for point in currentLine.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(Color.black, lineWidth: 2)
                    }
                    .frame(width: canvasSize.width, height: canvasSize.height)
                    .background(Color.white)
                    
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                currentLine.append(value.location)
                            }
                            .onEnded { _ in
                                lines.append(currentLine)
                                currentLine = []
                            }
                    )
                }
            }
            .border(Color.gray.opacity(0.5))

            
            HStack {
                Button("Очистить") {
                    lines.removeAll()
                    currentLine.removeAll()
                }
                .padding()

                Button("Отменить") {
                    if !lines.isEmpty {
                        lines.removeLast()
                    }
                }
                .padding()
            }
        }
        .onDisappear {
            var updated = note
            updated.drawing = lines
            updated.paperStyle = style
            updated.title = title
            onSave(updated)
        }
    }
}
