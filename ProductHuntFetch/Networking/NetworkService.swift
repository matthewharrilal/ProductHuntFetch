//
//  NetworkService.swift
//  ProductHuntFetch
//
//  Created by Space Wizard on 7/23/24.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol: AnyObject {
    func performRequest() async throws -> ([UnsplashModel], [URL])
    func fetchImagesConcurrently(urls: [URL]) async -> AsyncStream<UIImage?>
}

class NetworkServiceImplementation: NetworkServiceProtocol {
    
    private let cache: NSCache = NSCache<NSURL, UIImage>()

    
    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func performRequest() async throws -> ([UnsplashModel], [URL]) {
        let url = URL(string: "https://api.unsplash.com/photos/?client_id=vFb7-y0ANLrO8ySozTnMKpqNI_Tpi7e2OlzAhweqGv0")!
        
        var imageURLs: [URL] = []
        async let results = fetchData(from: url)
        
        let data = try await results
        
        let unsplashObject = try JSONDecoder().decode([UnsplashModel].self, from: data)
        unsplashObject.forEach {
            if let imageString = $0.urls?.full, let imageURL = URL(string: imageString) {
                imageURLs.append(imageURL)
            }
        }
        
        return (unsplashObject, imageURLs)
    }
    
    func fetchImagesConcurrently(urls: [URL]) async -> AsyncStream<UIImage?> {
        AsyncStream { continuation in
            Task {
                await withTaskGroup( // Each task returns optional data
                    of: UIImage?.self) { taskGroup in
                        for url in urls {
                            
                            taskGroup.addTask {
                                do {
                                    if let cachedImage = self.cache.object(forKey: url as NSURL) {
                                        return cachedImage
                                    }
                                    
                                    let data = try await self.fetchData(from: url)
                                    if let image = UIImage(data: data) {
                                        self.cache.setObject(image, forKey: url as NSURL)
                                        return image
                                    } else {
                                        return nil
                                    }
                                }
                                catch {
                                    print("Error fetching data")
                                    return nil
                                }
                                
                            }
                        }
                        
                        for await image in taskGroup {
                            continuation.yield(image)
                        }
                        
                        continuation.finish()
                    }
            }
        }
    }
}
