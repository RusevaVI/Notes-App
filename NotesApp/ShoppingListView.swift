import SwiftUI
struct ShoppingListView: View {
    @State var note: Note
    var onSave: (Note) -> Void

    @State private var productName: String = ""
    @State private var productQuantity: String = ""

    var body: some View {
        VStack(spacing: 20) {
            let isAddDisabled =
                productName.trimmingCharacters(in: .whitespaces).isEmpty ||
                productQuantity.trimmingCharacters(in: .whitespaces).isEmpty

            TextField("", text: $note.title)
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
                        .foregroundColor(!isAddDisabled ? .green : .gray)
                }
                .disabled(isAddDisabled)
            }

            List {
                ForEach($note.product) { $product in
                    HStack {
                        Text(product.name)

                        Text("×\(product.quantity)")
                            .foregroundColor(.gray)
                    }
                    .strikethrough(product.isBought)
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
            onSave(note)
        }
    }

    func addProduct() {
        let name = productName.trimmingCharacters(in: .whitespaces)
        let quantity = productQuantity.trimmingCharacters(in: .whitespaces)

        guard !name.isEmpty, !quantity.isEmpty else { return }

        note.product.append(Product(name: name, quantity: quantity))
        productName = ""
        productQuantity = ""
    }
}
