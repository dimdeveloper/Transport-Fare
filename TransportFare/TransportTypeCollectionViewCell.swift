//
//  TransportTypeCollectionViewCell.swift
//  TransportFare
//
//  Created by TheMacUser on 21.09.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import UIKit

class TransportTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var transportTypeLabel: UILabel!
    @IBOutlet var transportTypeImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .cyan
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
