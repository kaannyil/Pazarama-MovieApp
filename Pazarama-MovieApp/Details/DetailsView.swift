//
//  DetailsView.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import UIKit

protocol DetailsViewInterface {
    func prepare()
}

class DetailsView: UIViewController {

    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis =  .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let actorsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let directorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let imdbRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    var viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

// MARK: - UI Configuration
extension DetailsView: DetailsViewInterface {
    func prepare() {
        view.addSubview(imageView)
        view.addSubview(infoStack)
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(yearLabel)
        infoStack.addArrangedSubview(actorsLabel)
        infoStack.addArrangedSubview(countryLabel)
        infoStack.addArrangedSubview(directorLabel)
        infoStack.addArrangedSubview(imdbRatingLabel)
        
        const()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Batman Begins"
        view.backgroundColor = .black
        imageView.backgroundColor = .red
        
        titleLabel.text = "Batman Begins"
        yearLabel.text = "2005"
        actorsLabel.text = "Christian Bale, Michael Caine, Ken Watanabe"
        countryLabel.text = "United States, United Kingdom"
        directorLabel.text = "Christopher Nolan"
        imdbRatingLabel.text = "8.2"
        
        infoStack.backgroundColor = .clear
    }
}

// MARK: - Constraints
extension DetailsView {
    private func const() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5),
            
            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            infoStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            infoStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            infoStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
}
