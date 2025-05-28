import SwiftUI

struct ProductDetailScreen : View {
    @Environment(AppFormatter.self) private var formater
    
    @State private var viewModel: ProductDetailViewModel
    
    init(info: ProductInfo, favoriteManager: FavoriteManager, navigator: ProductNavigator) {
        viewModel = ProductDetailViewModel(favoriteManager: favoriteManager, info: info, navigator: navigator)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    TabView {
                        ForEach(viewModel.carrosselImages(), id: \.self) { imageURL in
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "shippingbox.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .background(Color.accentColor)
                    .tabViewStyle(.page)
                    .frame(height: 220)
                    
                    Button(action: { viewModel.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                            .padding()
                    }
                    
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.product.title)
                            .font(.title)
                        Spacer()
                        Button {
                            viewModel.toggleFavorite()
                        } label: {
                            Star(active: viewModel.isFavorite)
                                .font(.title)
                        }
                    }
                    
                    Text(formater.formatCurrency(viewModel.product.price))
                        .bold()
                        .padding(.bottom, 16)
                    
                    Text(viewModel.product.description)
                        .padding(.bottom, 16)
                }
                .padding(.all, 16)
            }
        }
    }
}


#Preview {
    @Previewable @State var favorite: Bool = false
    ProductDetailScreen(
        info: ProductInfo(product: ProductForPreview.previewProduct(), favorite: false),
        favoriteManager: FavoritesPreview(),
        navigator: ProductNavigatorPreview()
    )
    .environment(AppFormatter())
}
