//
//  ContentView.swift
//  PhotoList
//
//  Created by Hao Luo on 8/5/20.
//  Copyright © 2020 Hao Luo. All rights reserved.
//

import SwiftUI

struct Photo: Codable, Identifiable {
    let id: String
    let author: String
    let width: CGFloat
    let height: CGFloat
    let url: String
    let download_url: String
}

final class Remote<DataType>: ObservableObject {
    
    enum State {
        case loading
        case loaded(DataType)
        case error(Error)
    }
    
    @Published private(set) var state: State = .loading
    
    private let url: URL
    private let transform: (Data) -> DataType?
    
    init(urlString: String, transform: @escaping (Data) -> DataType?) {
        self.url = URL(string: urlString)!
        self.transform = transform
    }
    
    func load() {
        URLSession(configuration: .default)
            .dataTask(with: url) { [weak self] (data, _, error) in
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    if let error = error {
                        self.state = .error(error)
                    } else if let data = data, let transformedData = self.transform(data) {
                        self.state = .loaded(transformedData)
                    } else {
                        fatalError("Unexpected case")
                    }
                }
            }
        .resume()
    }
}

struct PhotoListView: View {
    @ObservedObject private(set) var remote: Remote<[Photo]> = .init(
        urlString: "https://picsum.photos/v2/list",
        transform: { try? JSONDecoder().decode([Photo].self, from: $0) }
    )
    
    var body: some View {
        NavigationView {
            switch remote.state {
            case .loading:
                ActivityIndicatorView()
                    .onAppear { self.remote.load() }
            case let .loaded(photos):
                List {
                    ForEach(photos) { photo in
                        NavigationLink(destination: PhotoView(url: photo.download_url)) {
                            Text(photo.author)
                        }
                    }
                }
            case .error:
                Text("Failed to photo list")
            }
        }
    }
}

struct PhotoView: View {
    @ObservedObject private(set) var remote: Remote<UIImage>
    
    init(url: String) {
        self._remote = .init(
            initialValue: .init(
                urlString: url,
                transform: { UIImage(data: $0) }
            )
        )
    }
    
    var body: some View {
        switch remote.state {
        case .loading:
            ActivityIndicatorView()
                .onAppear { self.remote.load() }
            
        case let .loaded(image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(image.size, contentMode: .fit)
        case .error:
            Text("Failed to load image")
        }
    }
}

struct ActivityIndicatorView: UIViewRepresentable {
        
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }
}

struct ContentView: View {
    var body: some View {
        PhotoListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
