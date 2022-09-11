//
//  UIImageView+Extension.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

extension UIImageView {
    func loadImage(fromUrl url: String?, placeholder: UIImage?) {
        DispatchQueue.global().async { [weak self] in
            
            guard let stringURL = url, let url = URL(string: stringURL) else {
                return setImage(image: nil)
            }
            
            let request = URLRequest(url: url)
            
            func setImage(image: UIImage?) {
                DispatchQueue.main.async {
                    self?.image = image ?? placeholder
                }
            }
            
            if let imageData = URLCache.shared.cachedResponse(for: request)?.data, let cachedImage = UIImage(data: imageData) {
                setImage(image: cachedImage)
            } else {
                setImage(image: nil)
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
                    if let data = data,
                       let response = response,
                       let image = UIImage(data: data) {
                        
                        let cachedData = CachedURLResponse(response: response, data: data)
                        URLCache.shared.storeCachedResponse(cachedData, for: request)
                        setImage(image: image)
                    } else {
                        setImage(image: nil)
                    }
                })
                task.resume()
            }
        }
    }
}
