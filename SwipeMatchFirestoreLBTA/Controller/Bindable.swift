//
//  Bindable.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/15/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import Foundation

class Bindable<T>  {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
