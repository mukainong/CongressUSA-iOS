//
//  LegislatorDetails.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/18/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit

class LegislatorDetails: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var segueImage: UIImageView!
    @IBOutlet weak var tblLegislatorDetails: UITableView!
    
    @IBAction func backFunction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var starIcon: UIBarButtonItem!
    @IBAction func starFunction(_ sender: Any) {
        //        if starItem.image == UIImage(named: "Star-48.png") {
        //            starItem.image = UIImage(named: "Star Filled-50.png")
        //        }
        //        if starItem.image == UIImage(named: "Star Filled-50.png") {
        //            starItem.image = UIImage(named: "Star-48.png")
        //        }
        if !favouriteObjects.contains(bioguide_idString) {
            favouriteObjects.append(bioguide_idString)
            
            let defaults = UserDefaults.standard
            defaults.set(favouriteObjects, forKey: "favouriteLegKey")
            
            
            starIcon.image = UIImage(named: "Star Filled-50.png")
        }
        else {
            favouriteObjects.remove(object: bioguide_idString)
            
            let defaults = UserDefaults.standard
            defaults.set(favouriteObjects, forKey: "favouriteLegKey")
            
            
            starIcon.image = UIImage(named: "Star-48.png")
        }
    }
    
    
    var favouriteObjects = [String]()
    
    var localArray:[String] = ["","","","","","","","","","",""]
    
    let data:[String] = ["item1", "item2", "item3"]
    
    var bioguide_idString = ""
    
    var leftCellArray:[String] = ["First Name","Last Name","State","Birthday","Gender","Chamber","Fax No.","Twitter","Website","Office No.","Term ends on"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.array(forKey: "favouriteLegKey") != nil {
            favouriteObjects = UserDefaults.standard.array(forKey: "favouriteLegKey") as! [String]
            
            if favouriteObjects.contains(bioguide_idString) {
                starIcon.image = UIImage(named: "Star Filled-50.png")
            }
        }
        
        let urlString = "https://theunitedstates.io/images/congress/original/" + bioguide_idString + ".jpg"
        
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOf: url as URL) {
                segueImage.image = UIImage(data: data as Data)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = self.tblLegislatorDetails.dequeueReusableCell(withIdentifier: "legislatorDetailsCell", for: indexPath)
        //        cell.textLabel?.text = localArray[indexPath.row]
        let cell = self.tblLegislatorDetails.dequeueReusableCell(withIdentifier: "legislatorDetailsCell", for: indexPath) as! CustomCell2
        cell.leftCell.text = leftCellArray[indexPath.row]
        cell.rightCell.text = localArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localArray.count
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.removeNavigationBarItem()
        }
    
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

