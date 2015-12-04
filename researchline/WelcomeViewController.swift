//
//  WelcomeViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    Constants.userDefaults.setObject(Constants.STEP_READY, forKey: "registerStep")

    navigationController?.navigationBarHidden = true
  }

  @IBAction func touchUpInsideJoinStudyButton(sender: UIButton) {
    let storyboard = UIStoryboard(name: "Eligibility", bundle: nil)
    let controller = storyboard.instantiateInitialViewController()!

    navigationController?.pushViewController(controller, animated: true)
  }

  // MARK: Scroll View Delegate

  func scrollViewDidScroll(scrollView: UIScrollView) {
    let currentPage = Int(collectionView.contentOffset.x / self.collectionView.frame.size.width)
    pageControl.currentPage = currentPage
  }

  // MARK: Collection View Delegate

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return collectionView.bounds.size
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4;
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(indexPath.item), forIndexPath: indexPath)
     return cell;
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}