//
//  EmptyViewTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import UIKit

struct EmptyViewModel {
    
    var image: UIImage?
    var title: String
    
    init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
    }
    
}
