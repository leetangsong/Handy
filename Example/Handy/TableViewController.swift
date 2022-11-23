//
//  TableViewController.swift
//  TSHandyKit_Example
//
//  Created by leetangsong on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Handy
import ObjectiveC
#if canImport(GDPerformanceView_Swift)
import GDPerformanceView_Swift
#endif
class TableViewController: UITableViewController {

     override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        
        tableView.contentInset = UIEdgeInsets.init(top: HandyApp.naviBarHeight, left: 0, bottom: 0, right: 0)
        automaticallyAdjustsScrollViewInsets = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "maincell")
        handy.title = "首页"
        handy.naviTitleColor = .white
        handy.naviBackgroundColor = .blue
         DispatchQueue.main.asyncAfter(deadline: .now()+5) {
             UIView.animate(withDuration: 1) {
                 self.handy.naviBackgroundColor = .red
             }
         }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if canImport(GDPerformanceView_Swift)
        PerformanceMonitor.shared().start()
        #endif
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    var titles: [String] = ["导航栏","主题"]
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "maincell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let demoVC = storyboard?.instantiateViewController(withIdentifier: "navigationConfige") else { return }
            demoVC.modalPresentationStyle = .fullScreen
            self.present(demoVC, animated: true)
        }else if indexPath.row == 1{
            guard let demoVC = storyboard?.instantiateViewController(withIdentifier: "ThemeNavi") else { return }
            demoVC.modalPresentationStyle = .fullScreen
            self.present(demoVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
     Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
     Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
