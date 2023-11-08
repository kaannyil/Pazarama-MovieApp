//
//  CustomLabel.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 7.11.2023.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textSize: CGFloat, color: UIColor, lineCount: Int) {
        super.init(frame: .zero)
        font = .boldSystemFont(ofSize: textSize)
        textColor = color
        numberOfLines = lineCount
        
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        sizeToFit()
    }
}
