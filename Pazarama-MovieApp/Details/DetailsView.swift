//
//  DetailsView.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import UIKit
import NVActivityIndicatorView


protocol DetailsViewInterface {
    func prepare()
}

protocol DetailsViewModelOutPut: AnyObject {
    func getMovieDetails(_ movieDetails: MovieDetails)
    func getError(_ errorType: ErrorTypes)
    func changeLoading(_ isLoading: Bool)
}

final class DetailsView: UIViewController {
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis =  .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let imageView           = CustomImage()
    private let titleLabel          = CustomLabel(textSize: 16, color: .white, lineCount: 2)
    private let yearLabel           = CustomLabel(textSize: 16, color: .white, lineCount: 2)
    private let actorsLabel         = CustomLabel(textSize: 16, color: .white, lineCount: 2)
    private let countryLabel        = CustomLabel(textSize: 16, color: .white, lineCount: 2)
    private let directorLabel       = CustomLabel(textSize: 16, color: .white, lineCount: 2)
    private let imdbRatingLabel     = CustomLabel(textSize: 16, color: .white, lineCount: 2)
    private let activityIndicator   = NVActivityIndicatorView(frame: .zero, type: .lineScale,
                                                    color: .darkGray, padding: 0)
    
    var viewModel: DetailsViewModel
    var selectedID: String
    
    init(viewModel: DetailsViewModel, selectedID: String) {
        self.viewModel = viewModel
        self.selectedID = selectedID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.output = self
        viewModel.viewDidLoad()
        viewModel.fetchMovieDetails(selectedID)
    }
}

// MARK: - UI Configuration
extension DetailsView: DetailsViewInterface {
    func prepare() {
        view.addSubViews(imageView, infoStack, activityIndicator)
        infoStack.addArrangedSubViews(titleLabel, yearLabel, actorsLabel,
                                      countryLabel, directorLabel, imdbRatingLabel)
        const()
        
        view.backgroundColor = .black
        
        viewModel.changeLoading(isLoading: true)
    }
}

// MARK: - DetailsViewModel OutPut
extension DetailsView: DetailsViewModelOutPut {
    func getMovieDetails(_ movieDetails: MovieDetails) {
        DispatchQueue.main.async {
            
            if movieDetails.poster == "N/A" {
                self.imageView.image = UIImage(named: "noimage")
            } else {
                self.imageView.kf.setImage(with: URL(string: movieDetails.poster))
            }
            
            self.titleLabel.text = "Title: \(movieDetails.title)"
            self.yearLabel.text = "Year: \(movieDetails.year)"
            self.actorsLabel.text = "Actors: \(movieDetails.actors)"
            self.countryLabel.text = "Country: \(movieDetails.country)"
            self.directorLabel.text = "Director: \(movieDetails.director)"
            self.imdbRatingLabel.text = "IMDB Rating: \(movieDetails.imdbRating)"
        }
    }
    
    func getError(_ errorType: ErrorTypes) {
        print(errorType)
    }
    
    func changeLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
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
            
            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            infoStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            infoStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            infoStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        activityIndicator.pintoCenter(superView: view)
    }
}
