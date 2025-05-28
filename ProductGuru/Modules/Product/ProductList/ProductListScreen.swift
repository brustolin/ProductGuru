import SwiftUI

struct ProductListScreen : View {
    @State private var viewModel: ProductListViewModel
    
    init(favoriteManager: FavoriteManager, navigator: ProductNavigator, api: ProductAPI) {
        self.viewModel = ProductListViewModel(favoriteManager: favoriteManager, navigator: navigator, api: api)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .list:
                ProductList(viewModel: viewModel)
            case .errorNetwork:
                VStack {
                    ErrorView(reason: .network)
                    ActionButton(text: "TRY AGAIN", action: viewModel.load)
                }
            case .errorUnknown:
                VStack {
                    ErrorView(reason: .unknown)
                    ActionButton(text: "TRY AGAIN", action: viewModel.load)
                }
            case .noProduct:
                EmptyProductList(refresher: viewModel)
            case .loading:
                ProgressView()
            }
        }
        .toolbar(content: {
            if viewModel.warning?.isEmpty == false {
                ToolbarItem {
                    Button(action: viewModel.displayWarning) {
                        Image(systemName: "wifi.slash")
                            .foregroundStyle(.red)
                    }
                }
            }
        })
        .navigationTitle("Products")
        .alert("Warning", isPresented: $viewModel.shouldDisplayWarning) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.warning ?? "An error occurred while loading the products.")
        }
    }
}

#Preview {
    ProductListScreen(favoriteManager: FavoritesPreview(), navigator: ProductNavigatorPreview(), api: ProductAPIPreview())
        .environment(AppFormatter())
}
