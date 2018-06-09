//
//  ViewController.swift
//  nestedCollectionViews
//
//  Created by Alex on 6/8/18.
//  Copyright © 2018 SweatNet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    let model: [[UIColor]] = generateRandomData()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outerCell", for: indexPath) as! OuterCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath){
        guard let outerCollectionViewCell = cell as? OuterCollectionViewCell else { return }
        let innerCellDelegatesInstance = innerCellDelegates(withModel: self.model)
        outerCollectionViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: innerCellDelegatesInstance, forRow: indexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class innerCellDelegates: NSObject,UICollectionViewDataSource, UICollectionViewDelegate {
    let model: [[UIColor]]
    
    init(withModel model: [[UIColor]]){
        self.model = model
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return self.model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "innerCell",
                                                      for: indexPath as IndexPath)
        
        cell.backgroundColor = self.model[collectionView.tag][indexPath.item]
        
        return cell
    }
}

