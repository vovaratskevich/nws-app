//
//  ImageService.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 24.01.22.
//


import UIKit

enum ImageServiceError: Error {
    case loadError
    case gettingDataError
    case parseError
}

class ImageService {
    
    let session = URLSession.shared
    
    
    func load(with url: String, complition: @escaping(Result<UIImage>) -> ()) {
        
//        Use complition from main thread
        
        guard let url = URL(string: url) else {
            complition(.failure(error: ErroService.failedURL))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                complition(.failure(error: ErroService.failedLoadData))
                return
            }

            guard let image = UIImage(data: data) else {
                complition(.failure(error: ErroService.failedParse))
                return
            }
            
            complition(.success(value: image))
        }.resume()
    }
    
}

extension UIImageView {
    
    func setImage(with url: String) {
        ImageService().load(with: url) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self?.image = data
                }
            }

        }
    }
    
}
