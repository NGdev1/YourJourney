//
//  PlaceViewControllerCollectionView.swift
//  YourJourney
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

extension PlaceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard place != nil else {
            return 0
        }
        
        guard place.photos != nil else {
            return 0
        }
        
        return place.photos!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewImages.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        guard place != nil else {
            return cell
        }
        
        guard place.photos != nil else {
            return cell
        }
        
        let url = URL(string: place.photos![indexPath.row])
        cell.imageView.sd_setImage(with: url)
        
        return cell
    }
    
    
}
