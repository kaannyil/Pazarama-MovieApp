//
//  ViewController.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 4.11.2023.
//

import UIKit
import NVActivityIndicatorView

protocol HomeViewInterface {
    func prepare()
}

protocol HomeViewModelOutPut: AnyObject {
    func getMovies(_ searchMovies: SearchMovies)
    func getError(_ errorType: ErrorTypes)
    func changeNoMovieScreen(_ isNoData: Bool)
    func changeLoading(_ isLoading: Bool)
    func changePagination(_ isPaging: Bool)
}

class HomeView: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let sizeWidth = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.cornerRadius = 3
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let noMovieLabel = CustomLabel(textSize: 22, color: .red, lineCount: 1)
    private let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .lineScale,
                                                            color: .lightGray, padding: 0)
    
    private let searchController = UISearchController()
    private let viewModel: HomeViewModel
    private let baseSearchText = "Batman"
    private var lastSearchText = ""
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
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
        viewModel.fetchSearchMovies(baseSearchText)
    }
}

// MARK: - UI Configuration
extension HomeView: HomeViewInterface {
    func prepare() {
        title = "OMDB Movies"
        
        view.addSubViews(collectionView, noMovieLabel, activityIndicator)
        
        delegates()
        const()
        
        navigationItem.searchController = searchController
        
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.placeholder = "Search Movie / Series / Episode"
        searchController.searchBar.text = baseSearchText
        
        lastSearchText = baseSearchText
        
        view.backgroundColor = .black
        collectionView.backgroundColor = .clear
        noMovieLabel.backgroundColor = .black
        noMovieLabel.text = "No Movie Found"
        
        noMovieLabel.isHidden = true
        viewModel.changeLoading(isLoading: true)
        viewModel.changePagination(isPaging: false)
    }
}

// MARK: - HomeViewModel OutPut
extension HomeView: HomeViewModelOutPut {
    
    func getMovies(_ searchMovies: SearchMovies) {
        DispatchQueue.main.async {
            movieArray.append(contentsOf: searchMovies.search)
            self.collectionView.reloadData()
            self.viewModel.isPaging = true
        }
    }
    
    func getError(_ errorType: ErrorTypes) {
        print(errorType)
    }
    
    func changeNoMovieScreen(_ isNoData: Bool) {
        DispatchQueue.main.async {
            if isNoData {
                self.collectionView.isHidden = isNoData
                self.noMovieLabel.isHidden = !isNoData
            } else {
                self.collectionView.isHidden = isNoData
                self.noMovieLabel.isHidden = !isNoData
            }
        }
    }
    
    func changeLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    func changePagination(_ isPaging: Bool) {
        if isPaging {
            viewModel.loadNextValues(lastSearchText)
        } else {
            viewModel.isPaging = false
        }
    }
}

// MARK: - Delegates
extension HomeView {
    private func delegates() {
        searchController.searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - SearchBar
extension HomeView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        lastSearchText = searchController.searchBar.text ?? ""
        
        movieArray.removeAll()
        
        viewModel.newSearching()
        viewModel.changeLoading(isLoading: true)
        viewModel.fetchSearchMovies(lastSearchText)
    }
}

// MARK: - CollectionView
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = movieArray[indexPath.row]
        cell.configCell(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeWidth = collectionView.frame.width
        return CGSize(width: sizeWidth, height: sizeWidth / 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieService: MovieService = NetworkManager()
        let detailsViewModel = DetailsViewModel(movieService: movieService)
        let detailView = DetailsView(viewModel: detailsViewModel, 
                                     selectedID: movieArray[indexPath.row].imdbID)
        navigationController?.pushViewController(detailView, animated: true)
    }
}

// MARK: - Pagination
extension HomeView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        viewModel.scrollViewDidScroll(offsetY: offsetY, contentHeight: contentHeight, height: height)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Constraints
extension HomeView {
    private func const() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        noMovieLabel.pinToEdges(superview: collectionView)
        activityIndicator.pintoCenter(superView: collectionView)
    }
}
