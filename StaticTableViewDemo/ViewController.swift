//
//  ViewController.swift
//  StaticTableViewDemo
//
//  Created by Mac on 2021/8/23.
//

import UIKit

// table view static cell && dynamic cell
class ViewController: UITableViewController {
    
    @IBOutlet weak var static1: UILabel!
    @IBOutlet weak var static2: UILabel!
    @IBOutlet weak var static3: UILabel!
    
    var dynamicRowArray: [Int] = (0..<10).sorted()
    var dynamicSectionArray: [Int] = (0..<5).sorted()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // change static
        static1.text = "one cell"
        static2.text = "tow cell"
        static3.text = "three cell"
        
        tableView.register(UINib(nibName: "CostomTableViewCell", bundle: nil), forCellReuseIdentifier: "CostomTableViewCell")
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        super.numberOfSections(in: tableView) + dynamicSectionArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= 1 {
            return dynamicRowArray.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section >= 1 {
            return 44
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section >= 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostomTableViewCell", for: indexPath) as! CostomTableViewCell
            if indexPath.section > 1 {
                cell.dynamic.text = "dynamicSection:\(dynamicSectionArray[indexPath.section - 2])Row\(dynamicRowArray[indexPath.row])"
            } else {
                cell.dynamic.text = "dynamicRow:\(dynamicRowArray[indexPath.row])"
            }
            return cell
        }
        return  super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section >= 1 {
            return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: 1))
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    // 自定义动态section 的时候
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        5
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
}

