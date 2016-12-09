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
        } else {
            favouriteObjects.remove(object: bioguide_idString)
            
            let defaults = UserDefaults.standard
            defaults.set(favouriteObjects, forKey: "favouriteLegKey")
            
            
            starIcon.image = UIImage(named: "Star-48.png")
        }
    }
    
//    var favouriteJSONObjects = [[String:AnyObject]]()
//    
//    var localJSONObject = [String:AnyObject]()
    
    var favouriteObjects = [String]()
    
    var bioguide_idString = ""
    
    var localArray:[String] = ["","","","","","","","","","","",""]
    
    var leftCellArray:[String] = ["First Name","Last Name","State","Birthday","Gender","Chamber","Fax No.","Twitter","Facebook","Website","Office No.","Term ends on"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.array(forKey: "favouriteLegKey") != nil {
            favouriteObjects = UserDefaults.standard.array(forKey: "favouriteLegKey") as! [String]
            
            if favouriteObjects.contains(bioguide_idString) {
                starIcon.image = UIImage(named: "Star Filled-50.png")
            }
        }
        
//        if UserDefaults.standard.array(forKey: "favouriteLegJSONKey") != nil {
//            favouriteJSONObjects = UserDefaults.standard.array(forKey: "favouriteLegJSONKey") as! [[String:AnyObject]]
//        }
        
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
        print(indexPath.row)
        
        let cell = self.tblLegislatorDetails.dequeueReusableCell(withIdentifier: "legislatorDetailsCell", for: indexPath) as! CustomCell2
        
        cell.rightCellButton.isHidden = true
        
        if indexPath.row < 7 || indexPath.row > 9 {
            cell.leftCell.text = leftCellArray[indexPath.row]
            cell.rightCell.text = localArray[indexPath.row]
            
            return cell
        } else if indexPath.row == 7{
            cell.rightCellButton.isHidden = false
            cell.rightCell.isHidden = true
            cell.leftCell.text = leftCellArray[indexPath.row]
            cell.rightCellButton.setTitle("Twitter Link", for: .normal)
            cell.web = NSURL(string: "http://twitter.com/"+localArray[indexPath.row])! as URL
            
            return cell
        } else if indexPath.row == 8{
            cell.rightCellButton.isHidden = false
            cell.rightCell.isHidden = true
            cell.leftCell.text = leftCellArray[indexPath.row]
            cell.rightCellButton.setTitle("Facebook Link", for: .normal)
            cell.web = NSURL(string: "http://facebook.com/"+localArray[indexPath.row])! as URL
            
            return cell
        } else {
            cell.rightCellButton.isHidden = false
            cell.rightCell.isHidden = true
            cell.leftCell.text = leftCellArray[indexPath.row]
            cell.rightCellButton.setTitle("Website Link", for: .normal)
            cell.web = NSURL(string: localArray[indexPath.row])! as URL
            
            return cell
        }
        
//        } else {
//            let cell = self.tblLegislatorDetails.dequeueReusableCell(withIdentifier: "legislatorDetailsCell2", for: indexPath) as! CustomCell3
//            cell.leftCell.isHidden = false
//            cell.leftCell.text = leftCellArray[indexPath.row]
//            cell.rightCell.titleLabel?.text = localArray[indexPath.row]
//        
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localArray.count
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.removeNavigationBarItem()
//    }
    
    func openUrl(url:String) {
        UIApplication.shared.openURL(NSURL(string: "http://google.com")! as URL)
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

