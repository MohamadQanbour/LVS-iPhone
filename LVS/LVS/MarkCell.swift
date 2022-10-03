//
//  MarkTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/24/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class MarkTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    var mark: MaterialMark! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var materialTitle: UILabel!
    @IBOutlet weak var exams: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.exams.delegate = self
        self.exams.dataSource = self
        self.exams.backgroundColor = Colors.getInstance().colorBackgroundLight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh() {
        self.exams.reloadData()
    }

    func updateUI()
    {
        materialTitle.adjustsFontSizeToFitWidth = true
        materialTitle.text = mark.MaterialTitle
        materialTitle.textColor = UIColor.white
        materialTitle.backgroundColor = Colors.getInstance().colorPrimaryLight
        
        backgroundCardView.backgroundColor = Colors.getInstance().colorBackgroundLight
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        backgroundCardView.layer.cornerRadius = 5.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.mark.Exams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Exam Cell", for: indexPath) as! ExamCollectionViewCell
        
        // Configure the cell
        cell.exam = self.mark.Exams[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.exams.frame.width / 2) - 5 , height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}
