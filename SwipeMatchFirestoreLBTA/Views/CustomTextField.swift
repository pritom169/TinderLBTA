//
//  CustomTextField.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/14/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding : CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: 50)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
