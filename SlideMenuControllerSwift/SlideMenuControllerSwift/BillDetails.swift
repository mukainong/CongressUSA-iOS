//
//  BillDetails.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/19/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit

class BillDetails: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var segueMessage: UITextView!
    
    @IBOutlet weak var tblBillDetails: UITableView!
    
    @IBAction func backFunction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var starIcon: UIBarButtonItem!
    
    @IBAction func starFunction(_ sender: Any) {
        if !favouriteObjects.contains(bill_idString) {
            favouriteObjects.append(bill_idString)
            
            let defaults = UserDefaults.standard
            defaults.set(favouriteObjects, forKey: "favouriteBillKey")
            
            
            starIcon.image = UIImage(named: "Star Filled-50.png")
        } else {
            favouriteObjects.remove(object: bill_idString)
            
            let defaults = UserDefaults.standard
            defaults.set(favouriteObjects, forKey: "favouriteBillKey")
            
            
            starIcon.image = UIImage(named: "Star-48.png")
        }
    }
    
    var favouriteObjects = [String]()
    
    var bill_idString = ""
    
    var localMessage = ""
    
    var localArray:[String] = ["","","","","","","",""]
    
    var leftCellArray:[String] = ["Bill ID","Bill Type","Sponsor","Last Action","PDF","Chabmer","Last Vote","Status"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.array(forKey: "favouriteBillKey") != nil {
            favouriteObjects = UserDefaults.standard.array(forKey: "favouriteBillKey") as! [String]
            
            if favouriteObjects.contains(bill_idString) {
                starIcon.image = UIImage(named: "Star Filled-50.png")
            }
        }
        
        segueMessage.text = localMessage
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tblBillDetails.dequeueReusableCell(withIdentifier: "billDetailsCell", for: indexPath) as! CustomCell2
//        cell.leftCell.text = leftCellArray[indexPath.row]
//        cell.rightCell.text = localArray[indexPath.row]
//        return cell
        
        let cell = self.tblBillDetails.dequeueReusableCell(withIdentifier: "billDetailsCell", for: indexPath) as! CustomCell2
        
        cell.rightCellButton.isHidden = true
        
        if indexPath.row != 4 {
            cell.leftCell.text = leftCellArray[indexPath.row]
            cell.rightCell.text = localArray[indexPath.row]
            
            return cell
        } else{
            cell.rightCellButton.isHidden = false
            cell.rightCell.isHidden = true
            cell.leftCell.text = leftCellArray[indexPath.row]
            cell.rightCellButton.setTitle("PDF Link", for: .normal)
            cell.web = NSURL(string: localArray[indexPath.row])! as URL
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localArray.count
    }
}
