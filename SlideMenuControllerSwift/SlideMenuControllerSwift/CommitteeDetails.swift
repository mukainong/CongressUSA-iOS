//
//  CommitteeDetails.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/19/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit

class CommitteeDetails: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var segueMessage: UILabel!
    @IBOutlet weak var tblCommitteeDetails: UITableView!
    
    @IBAction func backFunction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var localMessage = ""
    
    var localArray:[String] = ["","","","",""]
    
    var leftCellArray:[String] = ["ID","Parent ID","Chamber","Office","Contact"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segueMessage.text = localMessage
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCommitteeDetails.dequeueReusableCell(withIdentifier: "committeeDetailsCell", for: indexPath) as! CustomCell2
        cell.leftCell.text = leftCellArray[indexPath.row]
        cell.rightCell.text = localArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localArray.count
    }
    
}
