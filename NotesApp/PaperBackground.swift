import SwiftUI

struct PaperBackground: View {
    var style: DrawingView.PaperStyle
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                switch style {
                case .blank:
                    break
                    
                case .grid:
                    let spacing: CGFloat = 25
                    
                    for x in stride(from: 0, through: size.width, by: spacing) {
                        var path = Path()
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                        context.stroke(path, with: .color(.gray.opacity(0.4)), lineWidth: 0.5)
                    }
                    
                    for y in stride(from: 0, through: size.height, by: spacing) {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(.gray.opacity(0.4)), lineWidth: 0.5)
                    }
                    
                case .lines:
                    let spacing: CGFloat = 30
                    
                    for y in stride(from: 0, through: size.height, by: spacing) {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(.blue.opacity(0.4)), lineWidth: 1)
                    }
                }
            }
        }
    }
}
