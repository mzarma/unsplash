//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController, UISearchBarDelegate {
    let searchBar = UISearchBar(frame: .zero)
    private var searched: (String) -> Void = { _ in }
    
    convenience init(_ searched: @escaping (String) -> Void) {
        self.init()
        self.searched = searched
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
    }
    
    private func setUpSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let term = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        searched(term)
    }
}
