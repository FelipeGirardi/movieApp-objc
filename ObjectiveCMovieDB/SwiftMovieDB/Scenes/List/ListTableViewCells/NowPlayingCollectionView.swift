//
//  NowPlayingCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Henrique Figueiredo Conte on 20/08/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import UIKit


class NowPlayingCollectionView: UITableViewCell {
    
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate, forRow row: Int) {
        
        nowPlayingCollectionView.dataSource = dataSource
        nowPlayingCollectionView.delegate = delegate
    }
}

extension NowPlayingCollectionView: UICollectionViewDelegate {
    
}



