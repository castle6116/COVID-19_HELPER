//
//  SideMenuController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/11.
//

import UIKit

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView: UITableView!
    
    var items = ["사용방법","공지사항","라이센스","어플 버전"]
    
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
        cell.menuLabel.text = items[indexPath.row]
        if items[indexPath.row] == "사용방법"{
            
        }else if items[indexPath.row] == "공지사항"{
            
        }else if items[indexPath.row] == "라이센스"{
            
        }else if items[indexPath.row] == "어플 버전"{
            cell.versionLabel?.text = version
        }
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
