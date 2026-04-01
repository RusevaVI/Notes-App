
import Foundation
struct Product: Identifiable, Equatable,Hashable {
    let id = UUID()      
    var name: String
    var quantity: String
    var isBought: Bool = false
}
