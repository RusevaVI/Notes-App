import SwiftUI
struct ShoppingListView: View {
    @State private var title: String
    @State private var productName: String = ""
    @State private var productQuantity: String = ""
    @State private var products: [Product] = []
    var onSave: (String, [Product]) -> Void
    
    init(initialTitle: String, initialProducts: [Product], onSave: @escaping (String,[Product]) -> Void) {
        self._title = State(initialValue: initialTitle)
        self._products = State(initialValue: initialProducts)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(spacing: 20) {
            let canAdd = productName.trimmingCharacters(in: .whitespaces).isEmpty ||
            productQuantity.trimmingCharacters(in: .whitespaces).isEmpty
            TextField("", text: $title)
                .font(.title)
                .padding()
            HStack {
                TextField("Название", text: $productName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                TextField("Количество", text: $productQuantity)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action: addProduct) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(!canAdd ? .green : .gray)
                }
                .disabled(canAdd)
            }
            List {
                ForEach($products) { $product in
                    HStack {
                        Text(product.name)
                            
                        Text("×\(product.quantity)")
                            .foregroundColor(.gray)
                            
                    }.strikethrough(product.isBought)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                        .onTapGesture {
                            product.isBought.toggle()
                        }
                }
            }
            
            Spacer()
            
        }
        .padding()
        .onDisappear {
            onSave(title,products)
        }
    }
    
    
    func addProduct() {
        let name = productName.trimmingCharacters(in: .whitespaces)
        let quantity = productQuantity.trimmingCharacters(in: .whitespaces)
        
        guard !name.isEmpty, !quantity.isEmpty else { return }
        
        products.append(Product(name: name, quantity: quantity))
        productName = ""
        productQuantity = ""
    }
    
}
