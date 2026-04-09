import SwiftUI

struct DrawingView: View {

    @State var note: Note
    @State private var currentLine: [CGPoint] = []
    var onSave: (Note) -> Void
    let canvasSize = CGSize(width: 2000, height: 2000)

    enum PaperStyle: String, CaseIterable {
        case blank = "Пустой"
        case grid = "Клетка"
        case lines = "Линейка"
    }

    var body: some View {
        VStack {
            TextField("", text: $note.title)
                .font(.title)
                .padding(.leading, 10)

            Picker("Стиль", selection: $note.paperStyle) {
                ForEach(PaperStyle.allCases, id: \.self) { s in
                    Text(s.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            
            ScrollView([.horizontal], showsIndicators: true) {
                
                ScrollView([.vertical], showsIndicators: true) {
                    ZStack {
                        PaperBackground(style: note.paperStyle)
                            .frame(width: canvasSize.width, height: canvasSize.height)

                        
                        ForEach(note.drawing.indices, id: \.self) { i in
                            Path { path in
                                let line = note.drawing[i]
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
                                note.drawing.append(currentLine)
                                currentLine = []
                            }
                    )
                }
            }
            .border(Color.gray.opacity(0.5))

            
            HStack {
                Button("Очистить") {
                    note.drawing.removeAll()
                    currentLine.removeAll()
                }
                .padding()

                Button("Отменить") {
                    if !note.drawing.isEmpty {
                        note.drawing.removeLast()
                    }
                }
                .padding()
            }
        }
        .onDisappear {
            onSave(note)
        }
    }
}
