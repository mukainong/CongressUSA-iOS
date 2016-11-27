//
//  ActiveScene.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/19/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ActiveScene: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    var valueToPass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello world2")
        
        //Alamofire.request(<#T##url: URLConvertible##URLConvertible#>) // either call php or json file
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=bills&activestatus=true").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    self.arrRes = self.arrRes.sorted {($0["official_title"] as? String)! < ($1["official_title"] as? String)!}
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
        cell.textLabel?.text = dict["official_title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendBillSegue1" {
            let viewController = segue.destination as! BillDetails
            let path = tblJSON.indexPathForSelectedRow
            let leg = arrRes[(path?.row)!]
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
            
            if leg["bill_type"] is NSNull {
                viewController.localArray[2] = "N.A."
            } else {
                viewController.localArray[2] = leg["bill_type"] as! String
            }
            
            if leg["last_action_at"] is NSNull {
                viewController.localArray[3] = "N.A."
            } else {
                viewController.localArray[3] = leg["last_action_at"] as! String
            }
            
            if leg["last_action_at"] is NSNull {
                viewController.localArray[4] = "N.A."
            } else {
                viewController.localArray[4] = leg["last_action_at"] as! String
            }
            
            if leg["chamber"] is NSNull {
                viewController.localArray[5] = "N.A."
            } else {
                viewController.localArray[5] = leg["chamber"] as! String
            }
            
            if leg["last_vote_at"] is NSNull {
                viewController.localArray[6] = "N.A."
            } else {
                viewController.localArray[6] = leg["last_vote_at"] as! String
            }
            
            if leg["last_vote_at"] is NSNull {
                viewController.localArray[7] = "N.A."
            } else {
                viewController.localArray[7] = leg["last_vote_at"] as! String
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
