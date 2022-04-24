//
//  ImageWorker.swift

//
//  Created by Садык Мусаев on 25.01.2022.
//

import UIKit

protocol ImageWorkerProtocol{
    
    func requestImage(on imageUrl: String, handler: @escaping (UIImage) -> ())
    
    func saveImage(image: UIImage, with url: String)
    
    func createViewWithAsteroidAndDinosaur(model: AsteroidImageDataModel) -> UIView
}

class ImageWorker: ImageWorkerProtocol{
    
    var fileWorker: FileWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!
    
    let imageQuality: CGFloat = 1.0
    
    func requestImage(on imageUrl: String, handler: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let name = self.createImageNameFromImageURL(url: imageUrl)
            
            self.fileWorker.requestFile(with: name) { data in
                
                if let data = data, let image = UIImage(data: data){
                    
                    DispatchQueue.main.async {
                        //print("Картинка из хранилища")
                        handler(image)
                    }
                }
                
                else if data == nil{
                    
                    self.networkWorker.getData(from: imageUrl) { result in
                        
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let data):
                            
                            guard let compresdImage = UIImage(data: data)?.jpegData(compressionQuality: self.imageQuality), let image = UIImage(data: compresdImage) else { return } // Есть ли вариант лучше?
                            
                            DispatchQueue.main.async {
                                //print("Картинка из сети")
                                handler(image)
                            }
                            
                            self.saveImage(image: image, with: name)
                        }
                    }
                }
            }
        }
    }
    
    func saveImage(image: UIImage, with url: String) {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        let name = createImageNameFromImageURL(url: url)
        
        fileWorker.saveFile(with: name, file: imageData)
    }
    
    private func createImageNameFromImageURL(url: String) -> String {
        
        return String(url.split(separator: "/").last ?? "")
    }
    
    func createViewWithAsteroidAndDinosaur(model: AsteroidImageDataModel) -> UIView{
            
            let asteroidView = UIView(frame: CGRect(origin: .zero, size: model.imageSize))
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = asteroidView.bounds
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            
            asteroidView.layer.addSublayer(gradientLayer)
            
            if model.isDangerous{
                gradientLayer.colors = [Colors.dcL.cgColor, Colors.dcR.cgColor]
            }
            else{
                gradientLayer.colors = [Colors.ndcL.cgColor, Colors.ndcR.cgColor]
            }
            
//            switch model.asteroidSize{
//
//            case .small:
//
//                asteroidImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
//                asteroidImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//            case .medium:
//
//                asteroidImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//                asteroidImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//            case .big:
//
//                asteroidImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//                asteroidImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            }
            
        
        return asteroidView
    }
    
    private func draw(with size: CGSize, with colors: [CGColor]){
        
        UIGraphicsBeginImageContext(size)
        
        
        
        UIGraphicsEndImageContext()
    }
}
