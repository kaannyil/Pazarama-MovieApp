//
//  UIView+Extension.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 6.11.2023.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...){
        views.forEach { view in
            addSubview(view)
        }
    }
    
    func addArrangedSubViews(_ views: UIView...){
        guard let stackView = self as? UIStackView else {
            print("Use addArrangedViews extension with UIStackView")
            return
        }
        
        views.forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    func pinToEdges(superview : UIView){
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func pintoCenter (superView : UIView){
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            centerYAnchor.constraint(equalTo: superView.centerYAnchor),
            heightAnchor.constraint(equalToConstant: 50),
            widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
