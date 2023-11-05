//
//  DetailsViewModel.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import Foundation

protocol DetailsViewModelInterface {
    var view: DetailsView? { get }
    func viewDidLoad()
}

class DetailsViewModel: DetailsViewModelInterface {
    var view: DetailsView?
    
    func viewDidLoad() {
        view?.prepare()
    }
    
    
    
}
