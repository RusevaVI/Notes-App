import SwiftUI
struct Note: Identifiable, Equatable, Hashable {
    let id = UUID()
    var title: String
    var product: [Product] = []
    var isShopping: Bool = false
    var text: String = ""
    var drawing: [[CGPoint]] = []
    var isDrawing: Bool = false
    var paperStyle: DrawingView.PaperStyle = .grid
    var plan: Plan? = nil
}
