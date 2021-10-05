//
//  LazyImageView.swift
//  Friends
//
//  Created by Shariq Hussain on 05/10/21.
//

import UIKit

class LazyImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private let imageCache = NSCache<AnyObject,UIImage>()
    
    func loadImage(fromUrl imageUrl : URL, placeholderImage : String) -> Void {
        self.image = UIImage(named: placeholderImage)
        if let cachedImage = self.imageCache.object(forKey: imageUrl as AnyObject)
        {
            debugPrint("image loaded from cache for =\(imageUrl)")
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            [weak self] in
                if let imageData = try? Data(contentsOf: imageUrl)
                {
                    debugPrint("Image Downloaded From Server...")
                    if let image = UIImage(data: imageData)
                    {
                        DispatchQueue.main.async {
                            self?.imageCache.setObject(image, forKey: imageUrl as AnyObject)
                            self?.image = image
                        }
                       
                    }
                }
        }
    }

}
