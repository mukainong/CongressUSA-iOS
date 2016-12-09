//
//  FavouriteBills.swift
//  SlideMenuControllerSwift
//
//  Created by Mukai Nong on 11/27/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class FavouriteBills: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tblJSON: UITableView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBAction func searchFunction(_ sender: Any) {
        showHideSearch()
    }
    
    let searchBar = UISearchBar().self
    
    var flag : Bool = false
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    var filteredRes = [[String:AnyObject]]()
    
    var favouriteObjects = [String]()
    
    var allData = [[String:AnyObject]]()
    
    var allData1 = [[String:AnyObject]]()
    
    var allData2 = [[String:AnyObject]]()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            flag = true
            filteredRes = arrRes.filter{ (obj) -> Bool in
                let f = obj["official_title"] as? String
                return f!.range(of: searchText) != nil
            }
        } else {
            flag = false
        }
        self.tblJSON.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Fetching data...")
        
        createSearchBar()
        
        if UserDefaults.standard.array(forKey: "favouriteBillKey") != nil {
            favouriteObjects = UserDefaults.standard.array(forKey: "favouriteBillKey") as! [String]
        }
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=bills&activestatus=true").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.allData1 = resData as! [[String:AnyObject]]
                }
            }
        }
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=bills&activestatus=false").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.allData2 = resData as! [[String:AnyObject]]
                }
                
                self.allData = self.allData1 + self.allData2
                
                self.arrRes.removeAll()
                
                for name in self.favouriteObjects {
                    let object = self.allData.filter{($0["bill_id"] as? String!)! == name}[0]
                    self.arrRes.append(object)
                }
                
                self.arrRes = self.arrRes.sorted {($0["introduced_on"] as? String)! > ($1["introduced_on"] as? String)!}
                
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
                
                SwiftSpinner.hide()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        
        SwiftSpinner.show("Fetching data...")
        
        if UserDefaults.standard.array(forKey: "favouriteBillKey") != nil {
            favouriteObjects = UserDefaults.standard.array(forKey: "favouriteBillKey") as! [String]
        }
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=bills&activestatus=true").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.allData1 = resData as! [[String:AnyObject]]
                }
            }
        }
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=bills&activestatus=false").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.allData2 = resData as! [[String:AnyObject]]
                }
                
                self.allData = self.allData1 + self.allData2
                
                self.arrRes.removeAll()
                
                for name in self.favouriteObjects {
                    let object = self.allData.filter{($0["bill_id"] as? String!)! == name}[0]
                    self.arrRes.append(object)
                }
                
                self.arrRes = self.arrRes.sorted {($0["introduced_on"] as? String)! > ($1["introduced_on"] as? String)!}
                
                self.tblJSON.reloadData()
                
                SwiftSpinner.hide()
            }
        }
    }
    
    func createSearchBar() {
        searchBar.placeholder = "enter you inputs"
        searchBar.delegate = self
    }
    
    func showHideSearch() {
        if self.tabBarController?.navigationItem.rightBarButtonItem?.image == UIImage(named: "Search-50")! {
            self.tabBarController?.navigationItem.titleView = searchBar
            searchButton.image = UIImage(named: "Cancel-50")!
            
        } else {
            self.tabBarController?.navigationItem.titleView = nil
            searchButton.image = UIImage(named: "Search-50")!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tblJSON.dequeueReusableCell(withIdentifier: "jsonCell", for: indexPath)
        
        let cell = self.tblJSON.dequeueReusableCell(withIdentifier: "jsonCell", for: indexPath) as! CustomCell4
        
        var dict = arrRes[indexPath.row]
        
        if flag {
            dict = filteredRes[indexPath.row]
        } else {
            dict = arrRes[indexPath.row]
        }
        
        cell.label1.text = dict["bill_id"] as? String
        cell.label1.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.label2.text = dict["official_title"] as? String
        cell.label2.numberOfLines = 3
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date: NSDate? = dateFormatterGet.date(from: (dict["introduced_on"]?.substring(with: NSRange(location: 0, length: 10)))!) as NSDate?
        
        cell.label3.text = dateFormatterPrint.string(from: date! as Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag {
            return filteredRes.count
        }
        return arrRes.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendBillSegue1" {
            let viewController = segue.destination as! BillDetails
            let path = tblJSON.indexPathForSelectedRow
            let leg : [String:AnyObject]
            
            if flag && searchBar.text != ""{
                leg = filteredRes[(path?.row)!] as [String:AnyObject]
            } else {
                leg = arrRes[(path?.row)!] as [String:AnyObject]
            }
            
            viewController.localMessage = leg["official_title"] as! String
            
            if leg["bill_id"] is NSNull {
                viewController.localArray[0] = "N.A."
            } else {
                viewController.localArray[0] = leg["bill_id"] as! String
            }
            
            if leg["bill_type"] is NSNull {
                viewController.localArray[1] = "N.A."
            } else {
                viewController.localArray[1] = leg["bill_type"] as! String
            }
            
            if leg["chamber"] is NSNull {
                viewController.localArray[2] = "N.A."
            } else {
                if leg["chamber"] as! String == "senate" {
                    let tmp1 = "Sen"
                    let tmp2 = leg["sponsor"]?["first_name"] as! String
                    let tmp3 = leg["sponsor"]?["last_name"] as! String
                    viewController.localArray[2] = tmp1 + " " + tmp2 + " " + tmp3
                } else {
                    let tmp1 = "Rep"
                    let tmp2 = leg["sponsor"]?["first_name"] as! String
                    let tmp3 = leg["sponsor"]?["last_name"] as! String
                    viewController.localArray[2] = tmp1 + " " + tmp2 + " " + tmp3
                }
            }
            
            if leg["last_action_at"] is NSNull {
                viewController.localArray[3] = "N.A."
            } else {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                
                let date: NSDate? = dateFormatterGet.date(from: (leg["last_action_at"]?.substring(with: NSRange(location: 0, length: 10)))!) as NSDate?
                
                viewController.localArray[3] = dateFormatterPrint.string(from: date! as Date)
            }
            
            var lastVersion = leg["last_version"] as? [String:AnyObject]
            
            if lastVersion?["urls"]?["pdf"] is NSNull {
                viewController.localArray[4] = "N.A."
            } else {
                viewController.localArray[4] = lastVersion?["urls"]?["pdf"] as! String
            }
            
            if leg["chamber"] is NSNull {
                viewController.localArray[5] = "N.A."
            } else {
                if leg["chamber"] as! String == "senate" {
                    viewController.localArray[5] = "Senate"
                } else {
                    viewController.localArray[5] = "House"
                }
            }
            
            if leg["last_vote_at"] is NSNull {
                viewController.localArray[6] = "N.A."
            } else {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                
                let date: NSDate? = dateFormatterGet.date(from: (leg["last_vote_at"]?.substring(with: NSRange(location: 0, length: 10)))!) as NSDate?
                
                viewController.localArray[6] = dateFormatterPrint.string(from: date! as Date)
            }
            
            if leg["history"]?["active"] is NSNull {
                viewController.localArray[7] = "N.A."
            } else {
                if leg["history"]?["active"] as! Bool {
                    viewController.localArray[7] = "Active"
                } else {
                    viewController.localArray[7] = "New"
                }
            }
            
            if leg["bill_id"] is NSNull {
                viewController.bill_idString = "N.A."
            } else {
                viewController.bill_idString = leg["bill_id"] as! String
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let indexPath = tableView.indexPathForSelectedRow!
        //let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        //valueToPass = currentCell.textLabel?.text
        //performSegue(withIdentifier: "SendDataSegue", sender: self)
    }
    
}

