//
//  CustomImage.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 7.11.2023.
//

import Foundation
import UIKit

class CustomImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleToFill
    }
}
