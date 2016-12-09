//
//  SenateCommitteeScene.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/19/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class SenateCommitteeScene: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBAction func searchFunction(_ sender: Any) {
        showHideSearch()
    }
    
    @IBOutlet weak var tblJSON: UITableView!
    
    let searchBar = UISearchBar().self
    
    var flag : Bool = false
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    var filteredRes = [[String:AnyObject]]()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            flag = true
            filteredRes = arrRes.filter{ (obj) -> Bool in
                let f = obj["name"] as? String
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
        
        //Alamofire.request(<#T##url: URLConvertible##URLConvertible#>) // either call php or json file
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=committees").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    let r = resData as! [[String:AnyObject]]
                    self.arrRes = r.filter{$0["chamber"] as? String! == "senate"}
                    self.arrRes = self.arrRes.sorted {($0["name"] as? String)! < ($1["name"] as? String)!}
                }
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
                SwiftSpinner.hide()
            }
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblJSON.dequeueReusableCell(withIdentifier: "jsonCell", for: indexPath)
        var dict = arrRes[indexPath.row]
        
        if flag {
            dict = filteredRes[indexPath.row]
        } else {
            dict = arrRes[indexPath.row]
        }
        
        let var1 = dict["name"] as? String
        
        cell.textLabel?.text = var1!
        cell.detailTextLabel?.text = dict["committee_id"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag {
            return filteredRes.count
        }
        return arrRes.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendCommitteeSegue1" {
            let viewController = segue.destination as! CommitteeDetails
            let path = tblJSON.indexPathForSelectedRow
            let leg : [String:AnyObject]
            
            if flag && searchBar.text != ""{
                leg = filteredRes[(path?.row)!] as [String:AnyObject]
            } else {
                leg = arrRes[(path?.row)!] as [String:AnyObject]
            }
            
            viewController.localMessage = leg["name"] as! String
            
            if leg["committee_id"] == nil {
                viewController.localArray[0] = "N.A."
            } else {
                viewController.localArray[0] = leg["committee_id"] as! String
            }
            
            if leg["parent_committee_id"] == nil {
                viewController.localArray[1] = "N.A."
            } else {
                viewController.localArray[1] = leg["parent_committee_id"] as! String
            }
            
            if leg["chamber"] == nil {
                viewController.localArray[2] = "N.A."
            } else {
                viewController.localArray[2] = leg["chamber"] as! String
            }
            
            if leg["office"] == nil {
                viewController.localArray[3] = "N.A."
            } else {
                viewController.localArray[3] = leg["office"] as! String
            }
            
            if leg["phone"] == nil {
                viewController.localArray[4] = "N.A."
            } else {
                viewController.localArray[4] = leg["phone"] as! String
            }
            
            if leg["committee_id"] == nil {
                viewController.committee_idString = "N.A."
            } else {
                viewController.committee_idString = leg["committee_id"] as! String
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
