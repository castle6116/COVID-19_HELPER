//
//  SideMenuController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/11.
//

import UIKit

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var items = ["어플 버전"]
    @IBOutlet var tableView: UITableView!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.versionLabel?.text = version
        cell
        return cell
    }
}

//    extension SideMenuController: UITableViewDataSource {
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return items.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
//            cell.menuLabel?.text = items[indexPath.row]
//            cell.versionLabel?.text = version
//            return cell
//        }
//
//    }
