//
//  GoViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

class GoViewController: UIViewController {
    
    var favouriteObjects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        if UserDefaults.standard.array(forKey: "favouriteLegKey") != nil {
            favouriteObjects = UserDefaults.standard.array(forKey: "favouriteLegKey") as! [String]
            
            for element in favouriteObjects {
                print("It is here: -----------------------------------"+element)
            }
        }
    }
}
