//
//  Calendar.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/14.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class MyCalendar: UIViewController {

    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = ["January", "February", "March", "April", "May", "June" , "July", "August", "September", "October", "November", "December"]
    var currentMonthDays: Int {
        let dateComponents = DateComponents(year: self.currentYear, month: self.currentMonth)
        guard let date = Calendar.current.date(from: dateComponents) else {
            return 0
        }
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    var whatDateIsIt: Int {
        let dateComponents = DateComponents(year: self.currentYear, month: self.currentMonth)
        guard let date = Calendar.current.date(from: dateComponents) else {
            return 0
        }
        return Calendar.current.component(.weekday, from: date)
    }
    var howManyItemsShouldIAdd: Int {
        return self.whatDateIsIt - 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        
        self.setUp()
    }
    
    @IBAction func lastMonth(_ sender: UIButton) {
        self.currentMonth -= 1
        if self.currentMonth == 0 {
            self.currentMonth = 12
            self.currentYear -= 1
        }
        
        self.setUp()
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        self.currentMonth += 1
        if self.currentMonth == 13 {
            self.currentMonth = 1
            self.currentYear += 1
        }
        
        self.setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // 畫面旋轉時進入，重新計算畫面
        self.calendarView.collectionViewLayout.invalidateLayout()
        self.calendarView.reloadData()
    }
    
    func setUp() {
        self.timeLabel.text = self.months[self.currentMonth - 1] + " " + " \(self.currentYear)"
        
        self.calendarView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MyCalendar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: 40)
    }
}

extension MyCalendar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentMonthDays + self.howManyItemsShouldIAdd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let label = cell.contentView.subviews.first as? UILabel {
            if indexPath.row < self.howManyItemsShouldIAdd {
                label.text = ""
            }
            else {
                label.text = "\(indexPath.row + 1 - self.howManyItemsShouldIAdd)"
            }
        }
        return cell
    }
}

extension MyCalendar: UICollectionViewDelegate {
    
}
