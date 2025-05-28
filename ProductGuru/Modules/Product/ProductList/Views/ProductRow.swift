import SwiftUI

struct ProductRow : View {
    @Environment(AppFormatter.self) private var formater
    
    var info: ProductInfo
    var body: some View {
        HStack {
            ZStack(alignment: .bottomLeading) {
                RemoteImage(url: info.product.images.first ?? "") {
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                }
                .frame(width: 100, height: 100)
                .background(.accent)
                
                if info.favorite {
                    ZStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.accent)
                            .padding(.all, 4)
                    }
                    .background(.yellow)
                    .clipShape(RoundedCorner(radius: 12,corners: .topRight))
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(info.product.title)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    Text("\(formater.formatCurrency(info.product.price))")
                }.padding(.bottom, 8)
                Text(info.product.description)
                    .lineLimit(2)
            }.padding(.trailing)
        }
        .background(Color.cardBackground)
        .cornerRadius(16)
        .frame(height: 100)
    }
}


#Preview {
    @Previewable @State var rowContent: ProductInfo = ProductInfo(product: ProductForPreview.previewProduct(), favorite: true)
    
    ProductRow(info: rowContent)
        .environment(AppFormatter())
}
