//
//  RandomPhotoViewController.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 07/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class RandomPhotoViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private var dataSource: UICollectionViewDataSource!
    private var delegate: UICollectionViewDelegateFlowLayout!
    
    convenience init(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegateFlowLayout) {
        self.init()
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        collectionView.backgroundColor = .white
        
        let photoCellNib = UINib(nibName: "PhotoCell", bundle: nil)
        collectionView.register(photoCellNib, forCellWithReuseIdentifier: "PhotoCell")
        let noPhotoCellNib = UINib(nibName: "NoPhotoCell", bundle: nil)
        collectionView.register(noPhotoCellNib, forCellWithReuseIdentifier: "NoPhotoCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
