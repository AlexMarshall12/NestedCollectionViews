//
//  ViewController.swift
//  nestedCollectionViews
//
//  Created by Alex on 6/8/18.
//  Copyright © 2018 SweatNet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var outerCollectionView: UICollectionView!
    
    var dates = [Date?]()
    
    private var dataSources: [IndexPath : innerCellDelegates] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let allDates = Helper.generateRandomDate(daysBack: 500, numberOf: 5)
        self.dates = allDates.sorted(by: {
            $0!.compare($1!) == .orderedAscending
        })
        print("dates",self.dates)
        self.outerCollectionView.delegate = self
        self.outerCollectionView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        self.outerCollectionView!.collectionViewLayout = layout
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let first = (dates.first)!
        let last = (dates.last)!
        let months = last?.months(from: first!) ?? 0
        if let diff = last?.months(from: first!), diff <= 5 {
            return months + 5-diff
        } else {
            return months + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outerCell", for: indexPath) as! OuterCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/2, height: collectionView.bounds.size.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath){
        guard let outerCollectionViewCell = cell as? OuterCollectionViewCell else { return }
        if let dayDelegatesInstance = dataSources[indexPath] {
            outerCollectionViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: dayDelegatesInstance, forRow: indexPath.row)
        } else {
            let index = indexPath.item
            let firstPost = self.dates.first
            let monthDate = Calendar.current.date(byAdding: .month, value: index, to: firstPost as! Date)
            let monthInt = Calendar.current.component(.month, from: monthDate!)
            let yearInt = Calendar.current.component(.year, from: monthDate!)
            let monthDates = Helper.dates(self.dates as! [Date], withinMonth: monthInt, withinYear: yearInt)
            let dayDelegatesInstance = innerCellDelegates(firstDay: (monthDate?.startOfMonth())!, monthDates:monthDates)
            dataSources[indexPath] = dayDelegatesInstance
            outerCollectionViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: dayDelegatesInstance, forRow: indexPath.row)
        }
    }
    
}

class innerCellDelegates: NSObject,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let firstDay: Date
    let monthDates: [Date]
    let range: Range<Int>
    
    init(firstDay: Date, monthDates: [Date]){
        self.firstDay = firstDay
        self.monthDates = monthDates
        self.range = Calendar.current.range(of: .day, in: .month, for: firstDay)!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return range.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("sizing2")
        return CGSize(width: collectionView.bounds.size.width/CGFloat(range.count), height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "innerCell",
                                                      for: indexPath as IndexPath)
        print("cellforitemat")
        let components: Set<Calendar.Component> = [.day]
        let filtered = self.monthDates.filter { (date) -> Bool in
            Calendar.current.dateComponents(components, from: date).day == indexPath.item
        }
        if filtered.isEmpty == false {
            print(filtered,"filtered")
            cell.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.93, alpha:1.0)
        }
        return cell
    }
    
}

