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

class SenateCommitteeScene: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    var valueToPass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello world2")
        
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
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblJSON.dequeueReusableCell(withIdentifier: "jsonCell", for: indexPath)
        var dict = arrRes[indexPath.row]
        let var1 = dict["name"] as? String
        
        cell.textLabel?.text = var1!
        cell.detailTextLabel?.text = dict["committee_id"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendCommitteeSegue1" {
            let viewController = segue.destination as! CommitteeDetails
            let path = tblJSON.indexPathForSelectedRow
            let leg = arrRes[(path?.row)!]
            viewController.localMessage = leg["name"] as! String
            
            if leg["committee_id"] is NSNull {
                viewController.localArray[0] = "N.A."
            } else {
                viewController.localArray[0] = leg["committee_id"] as! String
            }
            
            if leg["parent_committee_id"] is NSNull {
                viewController.localArray[1] = "N.A."
            } else {
                viewController.localArray[1] = leg["parent_committee_id"] as! String
            }
            
            if leg["chamber"] is NSNull {
                viewController.localArray[2] = "N.A."
            } else {
                viewController.localArray[2] = leg["chamber"] as! String
            }
            
            if leg["committee_id"] is NSNull {
                viewController.localArray[3] = "N.A."
            } else {
                viewController.localArray[3] = leg["committee_id"] as! String
            }
            
            if leg["committee_id"] is NSNull {
                viewController.localArray[4] = "N.A."
            } else {
                viewController.localArray[4] = leg["committee_id"] as! String
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
