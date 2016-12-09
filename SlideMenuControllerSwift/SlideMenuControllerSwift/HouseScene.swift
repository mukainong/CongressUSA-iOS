//
//  StateScene.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/16/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

//class StateScene: UIViewController, UITableViewDataSource {
class HouseScene: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchButton: UIBarButtonItem!

    @IBAction func searchFunction(_ sender: Any) {
        showHideSearch()
    }
    
    @IBOutlet var tblJSON: UITableView!
    
    let searchBar = UISearchBar().self
    
    var flag : Bool = false
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
//    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredRes = [[String:AnyObject]]()
    
//    func filterContentForSearchText(searchText: String, scope: String = "All") {
//        
//        filteredRes = arrRes.filter{ (obj) -> Bool in
//            let f = obj["last_name"] as? String
//            return f!.range(of: searchText) != nil
//        }
//        self.tblJSON.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            flag = true
            filteredRes = arrRes.filter{ (obj) -> Bool in
                let f = obj["last_name"] as? String
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
        
        print("hello world1")
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=legislators").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    let r = resData as! [[String:AnyObject]]
                    self.arrRes = r.filter{$0["chamber"] as? String! == "house"}
                    self.arrRes = self.arrRes.sorted {($0["last_name"] as? String)! < ($1["last_name"] as? String)!}
                }
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
                SwiftSpinner.hide()
            }
        }
        
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        self.tblJSON.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
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
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        flag = true
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        flag = false
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblJSON.dequeueReusableCell(withIdentifier: "jsonCell", for: indexPath) as! CustomCell1
        //        let cell = self.tblJSON.dequeueReusableCell(withIdentifier: "jsonCell", for: indexPath)
        var dict = arrRes[indexPath.row]
        
        if flag && searchBar.text != ""{
            dict = filteredRes[indexPath.row]
        } else {
            dict = arrRes[indexPath.row]
        }
        
        let var1 = dict["first_name"] as? String
        let var2 = dict["last_name"] as? String
        let var3 = dict["bioguide_id"] as? String
        
        let urlString = "https://theunitedstates.io/images/congress/original/" + var3! + ".jpg"
        
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOf: url as URL) {
                cell.legimage.image = UIImage(data: data as Data)
            }
        }
        
        cell.title?.text = var1! + " " + var2!
        cell.subtitle?.text = dict["state_name"] as? String
        
        //        cell.textLabel?.text = var1! + " " + var2!
        //        cell.detailTextLabel?.text = dict["state_name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag && searchBar.text != ""{
            return filteredRes.count
        }
        return arrRes.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDataSegue" {
            let viewController = segue.destination as! LegislatorDetails
            let path = tblJSON.indexPathForSelectedRow
            let leg : [String:AnyObject]
            
            if flag && searchBar.text != ""{
                leg = filteredRes[(path?.row)!] as [String:AnyObject]
            } else {
                leg = arrRes[(path?.row)!] as [String:AnyObject]
            }
            //            viewController.localMessage = leg["first_name"] as! String
            
            if leg["first_name"] is NSNull {
                viewController.localArray[0] = "N.A."
            } else {
                viewController.localArray[0] = leg["first_name"] as! String
            }
            
            if leg["last_name"] is NSNull {
                viewController.localArray[1] = "N.A."
            } else {
                viewController.localArray[1] = leg["last_name"] as! String
            }
            
            if leg["state_name"] is NSNull {
                viewController.localArray[2] = "N.A."
            } else {
                viewController.localArray[2] = leg["state_name"] as! String
            }
            
            if leg["birthday"] is NSNull {
                viewController.localArray[3] = "N.A."
            } else {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                
                let date: NSDate? = dateFormatterGet.date(from: (leg["birthday"]?.substring(with: NSRange(location: 0, length: 10)))!) as NSDate?
                
                viewController.localArray[3] = dateFormatterPrint.string(from: date! as Date)
            }
            
            if leg["gender"] is NSNull {
                viewController.localArray[4] = "N.A."
            } else {
                if leg["gender"] as! String == "M" {
                    viewController.localArray[4] = "Male"
                } else {
                    viewController.localArray[4] = "Female"
                }
            }
            
            if leg["chamber"] is NSNull {
                viewController.localArray[5] = "N.A."
            } else {
                viewController.localArray[5] = leg["chamber"] as! String
            }
            
            if leg["fax"] is NSNull {
                viewController.localArray[6] = "N.A."
            } else {
                viewController.localArray[6] = leg["fax"] as! String
            }
            
            if leg["twitter_id"] is NSNull {
                viewController.localArray[7] = "N.A."
            } else {
                viewController.localArray[7] = leg["twitter_id"] as! String
            }
            
            if leg["facebook_id"] is NSNull {
                viewController.localArray[8] = "N.A."
            } else {
                viewController.localArray[8] = leg["facebook_id"] as! String
            }
            
            if leg["website"] is NSNull {
                viewController.localArray[9] = "N.A."
            } else {
                viewController.localArray[9] = leg["website"] as! String
            }
            
            if leg["office"] is NSNull {
                viewController.localArray[10] = "N.A."
            } else {
                viewController.localArray[10] = leg["office"] as! String
            }
            
            if leg["term_end"] is NSNull {
                viewController.localArray[11] = "N.A."
            } else {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                
                let date: NSDate? = dateFormatterGet.date(from: (leg["term_end"]?.substring(with: NSRange(location: 0, length: 10)))!) as NSDate?
                
                viewController.localArray[11] = dateFormatterPrint.string(from: date! as Date)
            }
            
            if leg["bioguide_id"] is NSNull {
                viewController.bioguide_idString = "N.A."
            } else {
                viewController.bioguide_idString = leg["bioguide_id"] as! String
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

//extension HouseScene : UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchText: searchController.searchBar.text!)
//    }
//}

