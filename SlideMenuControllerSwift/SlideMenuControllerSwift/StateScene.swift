//
//  HouseScene.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/16/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class StateScene: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBAction func filterFunction(_ sender: Any) {
        self.pickerView.isHidden = false
        tblJSON.isHidden = true
    }
    
    @IBOutlet var tblJSON: UITableView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [[String:AnyObject]]!
    }
    
    var objectsArray = [Objects]()
    
    var filteredRes = [[String:AnyObject]]()
    
    var filteredObjectsArray = [Objects]()
    
    var flag : Bool = false
    
    var letterArray:[String] = ["A", "C", "D", "F", "G", "H", "I", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "W"]
    
    var filteredLetterArray:[String] = []
    
    var stateArray:[String] = ["All States",
                               "Alabama",
                               "Alaska",
                               "American Samoa",
                               "Arizona",
                               "Arkansas",
                               "California",
                               "Colorado",
                               "Connecticut",
                               "Delaware",
                               "District Of Columbia",
                               "Federated States Of Micronesia",
                               "Florida",
                               "Georgia",
                               "Guam",
                               "Hawaii",
                               "Idaho",
                               "Illinois",
                               "Indiana",
                               "Iowa",
                               "Kansas",
                               "Kentucky",
                               "Louisiana",
                               "Maine",
                               "Marshall Islands",
                               "Maryland",
                               "Massachusetts",
                               "Michigan",
                               "Minnesota",
                               "Mississippi",
                               "Missouri",
                               "Montana",
                               "Nebraska",
                               "Nevada",
                               "New Hampshire",
                               "New Jersey",
                               "New Mexico",
                               "New York",
                               "North Carolina",
                               "North Dakota",
                               "Northern Mariana Islands",
                               "Ohio",
                               "Oklahoma",
                               "Oregon",
                               "Palau",
                               "Pennsylvania",
                               "Puerto Rico",
                               "Rhode Island",
                               "South Carolina",
                               "South Dakota",
                               "Tennessee",
                               "Texas",
                               "Utah",
                               "Vermont",
                               "Virgin Islands",
                               "Virginia",
                               "Washington",
                               "West Virginia",
                               "Wisconsin",
                               "Wyoming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Fetching data...")
        
//        createSearchBar()
        
        Alamofire.request("http://newapp2016-env.us-west-2.elasticbeanstalk.com/congress_responsive.php?database=legislators").responseJSON { (responseJSON) -> Void in
            if((responseJSON.result.value) != nil) {
                let swiftyJsonVar = JSON(responseJSON.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    self.arrRes = self.arrRes.sorted {($0["last_name"] as? String)! < ($1["last_name"] as? String)!}
                    
                    self.objectsArray = [Objects(sectionName: "A", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Alabama" || $0["state_name"] as? String! == "Alaska" || $0["state_name"] as? String! == "Arizona" || $0["state_name"] as? String! == "Arkansas"}), Objects(sectionName: "C", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "California" || $0["state_name"] as? String! == "Colorado" || $0["state_name"] as? String! == "Connecticut"}), Objects(sectionName: "D", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Delaware"}), Objects(sectionName: "F", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Florida"}), Objects(sectionName: "G", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Georgia"}), Objects(sectionName: "H", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Hawaii"}), Objects(sectionName: "I", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Idaho" || $0["state_name"] as? String! == "Illinois" || $0["state_name"] as? String! == "Indiana" || $0["state_name"] as? String! == "Iowa"}), Objects(sectionName: "K", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Kansas" || $0["state_name"] as? String! == "Kentucky"}), Objects(sectionName: "L", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Louisiana"}), Objects(sectionName: "M", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Maine" || $0["state_name"] as? String! == "Maryland" || $0["state_name"] as? String! == "Massachusetts" || $0["state_name"] as? String! == "Michigan" || $0["state_name"] as? String! == "Minnesota" || $0["state_name"] as? String! == "Mississippi" || $0["state_name"] as? String! == "Missouri" || $0["state_name"] as? String! == "Montana"}), Objects(sectionName: "N", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Nebraska" || $0["state_name"] as? String! == "Nevada"}), Objects(sectionName: "O", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Ohio" || $0["state_name"] as? String! == "Oklahoma" || $0["state_name"] as? String! == "Oregon"}), Objects(sectionName: "P", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Pennsylvania"}), Objects(sectionName: "R", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Rhode Island"}), Objects(sectionName: "S", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "South Carolina" || $0["state_name"] as? String! == "South Dakota"}), Objects(sectionName: "T", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Tennessee" || $0["state_name"] as? String! == "Texas"}), Objects(sectionName: "U", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Utah"}), Objects(sectionName: "V", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Vermont" || $0["state_name"] as? String! == "Virginia"}), Objects(sectionName: "W", sectionObjects: self.arrRes.filter{$0["state_name"] as? String! == "Washington" || $0["state_name"] as? String! == "West Virginia" || $0["state_name"] as? String! == "Wisconsin" || $0["state_name"] as? String! == "Wyoming"})]
                }
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
                SwiftSpinner.hide()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = filterButton
        self.pickerView.isHidden = true
        self.tblJSON.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if stateArray[row] != "All States" {
            flag = true
//            filteredRes = arrRes.filter{ (obj) -> Bool in
//                let f = obj["state_name"] as? String
//                return f!.range(of: stateArray[row]) != nil
//            }
        
            filteredRes = self.arrRes.filter{$0["state_name"] as? String! == stateArray[row]}
            self.filteredObjectsArray = [Objects(sectionName: stateArray[row][0], sectionObjects: filteredRes)]
            filteredLetterArray = [stateArray[row][0]]
        } else  {
            flag = false
        }
        
        self.pickerView.isHidden = true
        self.tblJSON.isHidden = false
        
        self.tblJSON.reloadData()
    }
    
//    func createSearchBar() {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "enter you inputs"
//        searchBar.delegate = self
//        
//        self.navigationItem.titleView = searchBar
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblJSON.dequeueReusableCell(withIdentifier: "jsonCell", for: indexPath) as! CustomCell1
        
//        var dict = arrRes[indexPath.row]
        var dict = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        
        if !flag {
            dict = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        } else {
            dict = filteredObjectsArray[indexPath.section].sectionObjects[indexPath.row]
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrRes.count
        if !flag {
            return objectsArray[section].sectionObjects.count
        } else {
            return filteredObjectsArray[section].sectionObjects.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !flag {
            return objectsArray.count
        } else {
            return filteredObjectsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !flag {
            return objectsArray[section].sectionName
        } else {
            return filteredObjectsArray[section].sectionName
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !flag {
            return self.letterArray
        } else {
            return self.filteredLetterArray
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDataSegue" {
            let viewController = segue.destination as! LegislatorDetails
            let path = tblJSON.indexPathForSelectedRow
//            let leg = arrRes[(path?.row)!]
            var leg = objectsArray[(path?.section)!].sectionObjects[(path?.row)!]
            
            if !flag {
                leg = objectsArray[(path?.section)!].sectionObjects[(path?.row)!]
            } else {
                leg = filteredObjectsArray[(path?.section)!].sectionObjects[(path?.row)!]
            }
            
            viewController.bioguide_idString = leg["bioguide_id"] as! String
            
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
//        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
//        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
//        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.setNavigationBarTitle("Legislators")
//    }
}

extension String {
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
}
