//
//  ViewController.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 4.11.2023.
//

import UIKit

protocol HomeViewInterface {
    func prepare()
}

protocol HomeViewModelOutPut: AnyObject {
    func getMovies(_ searchMovies: SearchMovies)
}

class HomeView: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let sizeWidth = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 8
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
    
    private var searchController = UISearchController()
    private var searchTimer: Timer?
    var viewModel: HomeViewModel
    let baseSearchText = "Batman"
    var firstTime: Bool = true
    
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.output = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        
        viewModel.fetchSearchMovies(searchText: baseSearchText)
        
    }
}

// MARK: - UI Configuration
extension HomeView: HomeViewInterface {
    func prepare() {
        
        title = "OMDB Movies"
        
        view.addSubview(collectionView)
        
        delegates()
        const()
        
        navigationItem.searchController = searchController
        
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.placeholder = "Search Movie / Series / Episode"
        searchController.searchBar.text = baseSearchText
        
        view.backgroundColor = .black
        collectionView.backgroundColor = .clear
    }
}

// MARK: - HomeViewModelOutPut
extension HomeView: HomeViewModelOutPut {
    func getMovies(_ searchMovies: SearchMovies) {
        movieArray = searchMovies.search
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        print(searchMovies)
    }
}

// MARK: - Delegates
extension HomeView {
    func delegates() {
        searchController.searchResultsUpdater = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - SearchBar
extension HomeView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()
        
        guard let text = searchController.searchBar.text else { return }
    
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
            if text == "" {
                return
            } else if self.firstTime {
                self.firstTime.toggle()
            } else {
                self.viewModel.fetchSearchMovies(searchText: text)
            }
        })
    }
}

// MARK: - CollectionView
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier,
                                                      for: indexPath) as! HomeCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeWidth = collectionView.frame.width
        return CGSize(width: sizeWidth, height: sizeWidth / 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewModel = DetailsViewModel()
        let detailView = DetailsView(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    
}
// MARK: - Constraints
extension HomeView {
    private func const() {
        NSLayoutConstraint.activate([
           collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
           collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
           collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
