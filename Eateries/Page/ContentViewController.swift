//
//  ContentViewController.swift
//  Eateries
//
//  Created by Aleksei Chudin on 04/02/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        switch index {
        case 0:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 1:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "wasIntroWatched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageButton.layer.cornerRadius = 10
        pageButton.clipsToBounds = true
        pageButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        pageButton.layer.borderColor = (#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)).cgColor
        
        switch index {
        case 0: pageButton.setTitle("Next", for: .normal)
        case 1: pageButton.setTitle("Open", for: .normal)
        default: break
        }
        
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
    }
    
}
