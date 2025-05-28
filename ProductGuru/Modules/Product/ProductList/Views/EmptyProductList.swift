import SwiftUI

protocol ProductListRefresher {
    func load()
}

struct EmptyProductList : View  {
    let refresher : ProductListRefresher
    
    var body: some View {
        VStack {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 80))
            Text("There is no product available")
                .font(.title)
            ActionButton(text: "RELOAD", action: refresher.load)
        }
        .foregroundStyle(Color.accentColor)
    }
}


class ProductListRefresherPreview: ProductListRefresher {
    func load() {
    }
}

#Preview {
    EmptyProductList(refresher: ProductListRefresherPreview())
}
