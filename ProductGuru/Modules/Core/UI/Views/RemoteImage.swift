import SwiftUI

/// escuelajs.co API images are not standardized for specific usage; they don’t have a default dimension and are often large.
/// This can cause some jankiness when using `AsyncImage` directly.
/// `RemoveImage` is a simple solution to properly load, resize, and cache images from a URL before displaying them.
/// The cache solution uses a straightforward in-memory cache.

@MainActor
@Observable class RemoteImageViewModel {
    var image: UIImage? = nil
    var isLoading: Bool = false
    
    func loadImage(url: String, for size: CGSize) {
        if let cached = ImageCache.shared.image(forKey: url) {
            image = cached
            return
        }
        
        isLoading = true
        Task {
            defer {
                self.isLoading = false
            }
            
            guard let endpoint = URL(string: url) else { return }
            
            do {
                var request = URLRequest(url: endpoint)
                request.cachePolicy = .returnCacheDataElseLoad
                
                let (data, _) = try await URLSession.shared.data(for: request)
                guard
                    let image = UIImage(data: data),
                    let thumb = await image.byPreparingThumbnail(ofSize: size)
                else { return }
                
                ImageCache.shared.setImage(thumb, forKey: url)
                self.image = thumb
            } catch {
                Log.error(error)
            }
        }
    }
}

struct RemoteImage<Placeholder: View> : View {
    @State private var viewModel = RemoteImageViewModel()
    var url: String
    var placeholder: () -> Placeholder
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                } else {
                    placeholder()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                viewModel.loadImage(url: url, for: geometry.size)
            }
        }
    }
}





