//
//  Gestures.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 01/08/22.
//

import UIKit

class MapGesture: UITapGestureRecognizer {
    var model: [EachAddress]?
    var indexPath: IndexPath?
    
    init(target: Any?, action: Selector?, model: [EachAddress], indexPath: IndexPath) {
        super.init(target: target, action: action)
        delegate = target as? UIGestureRecognizerDelegate
        self.model = model
        self.indexPath = indexPath
        numberOfTapsRequired = 1
    }
}
