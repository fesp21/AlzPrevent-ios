//
//  ConsentSlideViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class ConsentSlideViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var collectionView: UICollectionView!

  @IBAction func touchUpInsideNextButton(sender: UIButton) {
    let nextPage = Int(collectionView.contentOffset.x / self.collectionView.frame.size.width) + 1

    if nextPage == 11 {
      let storyboard = UIStoryboard(name: "Consent", bundle: nil)
      let controller = storyboard.instantiateViewControllerWithIdentifier("ConsentSharingOptionsViewController")

      navigationController?.pushViewController(controller, animated: true)
    } else {
      let contentOffset = CGPoint(x: Int(collectionView.bounds.width) * nextPage, y: 0)
      debugPrint("nextPage", nextPage, contentOffset)
      collectionView.setContentOffset(contentOffset, animated: true)
    }
  }

  // MARK: Collection View Delegate

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 11
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCellWithReuseIdentifier(String(indexPath.item), forIndexPath: indexPath)
  }

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return collectionView.bounds.size
  }
}