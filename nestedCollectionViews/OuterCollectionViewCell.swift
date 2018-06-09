//
//  OuterCollectionViewCell.swift
//  nestedCollectionViews
//
//  Created by Alex on 6/8/18.
//  Copyright © 2018 SweatNet. All rights reserved.
//

import UIKit

class OuterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var innerCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        innerCollectionView.delegate = dataSourceDelegate
        innerCollectionView.dataSource = dataSourceDelegate
        innerCollectionView.tag = row
        innerCollectionView.reloadData()
    }
}
