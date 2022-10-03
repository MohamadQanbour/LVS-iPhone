//
//  Attachments.swift
//  LVS
//
//  Created by Jalal on 12/17/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class Attachments: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.view.backgroundColor = Colors.getInstance().colorBackground
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return AttachmentList.getInstance().getAttachments().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Attachment Cell", for: indexPath) as! AttachmentCell
    
        // Configure the cell
        cell.attachment = AttachmentList.getInstance().getAttachments()[indexPath.row]
    
        return cell
    }

}
