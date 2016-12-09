//
//  AboutMeViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Mukai Nong on 11/28/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {
    
    @IBOutlet weak var myPicture: UIImageView!
    
    @IBOutlet weak var myName: UILabel!
    
    @IBOutlet weak var myNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "http://www-scf.usc.edu/~mnong/images/mukainong.jpg"
        
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOf: url as URL) {
                myPicture.image = UIImage(data: data as Data)
            }
        }
        
        myName.text = "Mukai Nong"
        
        myNumber.text = "631-721-3641"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.setNavigationBarTitle("About")
    }
}
