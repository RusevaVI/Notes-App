import Foundation

struct Plan: Identifiable, Equatable, Hashable  {
    let id = UUID()
    var text: String
    var date: Date
    
}
