import SwiftUI

struct ProductList : View {
    var viewModel: ProductListViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.products) { info in
                    Button {
                        viewModel.selectProduct(info)
                    } label: {
                        ProductRow(info:info)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            } footer: {
                if viewModel.hasMoreItens {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                        .onAppear(perform: viewModel.load)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
