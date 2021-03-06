//
//  FlowLayout.swift
//  TransportFare
//
//  Created by TheMacUser on 22.09.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import Foundation
import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    var leftInset: CGFloat = 0.0
//    required init(itemSize: CGSize?, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
//        super.init()
//        if let itemSize = itemSize {
//            self.itemSize = itemSize
//        }
//        self.minimumInteritemSpacing = minimumInteritemSpacing
//        self.minimumLineSpacing = minimumLineSpacing
//        self.sectionInset = sectionInset
//        sectionInsetReference = .fromSafeArea
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    self.minimumInteritemSpacing = 15.0
    


    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }
        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })

        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Get the total width of the cells on the same row
            let cellsTotalWidth = attributes.reduce(CGFloat(0)) { (partialWidth, attribute) -> CGFloat in
                partialWidth + attribute.size.width
            }

            // Calculate the initial left inset
            if #available(iOS 11.0, *) {
                let totalInset = collectionView!.safeAreaLayoutGuide.layoutFrame.width - cellsTotalWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(attributes.count - 1)
                leftInset = (totalInset / 2 * 10).rounded(.down) / 10 + sectionInset.left
            } else {
                let interItemSpacing = minimumInteritemSpacing * CGFloat(attributes.count - 1)
                let totalInset = collectionView!.layer.bounds.width - cellsTotalWidth - sectionInset.left - sectionInset.right - interItemSpacing
                
                leftInset = (totalInset / 2 * 10).rounded(.down) / 10 + sectionInset.left
            }
            

            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }
        
        return layoutAttributes
    }

}
