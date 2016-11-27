//
//  CommitteeTabBarController.swift
//  SlideMenuControllerSwift
//
//  Created by Mukai Nong on 11/24/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class CommitteeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.setNavigationBarTitle("Committees")
    }
}
