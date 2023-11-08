//
//  HomeCollectionViewCell.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis =  .vertical
        return stack
    }()
    
    private let imageView = CustomImage()
    private let titleLabel  = CustomLabel(textSize: 23, color: .white, lineCount: 4)
    private let yearLabel   = CustomLabel(textSize: 23, color: .white, lineCount: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubViews(imageView, stackView)
        stackView.addArrangedSubViews(titleLabel, yearLabel)
        const()
    }
    
    func configCell(_ movies: Search) {
        if movies.poster == "N/A" {
            imageView.image = UIImage(named: "noimage")
        } else {
            let imageUrl = URL(string: movies.poster)
            imageView.kf.setImage(with: imageUrl)
        }
        titleLabel.text = movies.title
        yearLabel.text = movies.year
    }
}

// MARK: - Constraints
extension HomeCollectionViewCell {
    private func const() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2/3),
            
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 50),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
        ])
    }
}
