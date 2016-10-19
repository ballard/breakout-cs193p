//
//  SettingsTableViewController.swift
//  breakout-cs193p
//
//  Created by Ivan on 07.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var bricksCountSegmentedController: UISegmentedControl!
    @IBAction func setBricksCount(_ sender: UISegmentedControl) {
        bricksCount = (sender.selectedSegmentIndex + 1) * 10
    }
    private var bricksCount: Int {
        get {
            return UserDefaultsSingleton.sharedInstance.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.BricksCount) as? Int ?? 30
        }
        set{
            UserDefaultsSingleton.sharedInstance.defaults!.set(
                newValue, forKey: UserDefaultsSingleton.Keys.BricksCount)
        }
    }
    
    @IBOutlet weak var gravitySlider: UISlider!
    @IBAction func setGravity(_ sender: UISlider) {
        gravity = CGFloat(sender.value)
    }
    private var gravity: CGFloat {
        get {
            return UserDefaultsSingleton.sharedInstance.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.Gravity) as? CGFloat ?? 0.75
        }
        set{
            UserDefaultsSingleton.sharedInstance.defaults!.set(
                newValue, forKey: UserDefaultsSingleton.Keys.Gravity)
        }
    }
    @IBOutlet weak var elasticitySlider: UISlider!
    @IBAction func setElasticity(_ sender: UISlider) {
        elasticity = CGFloat(sender.value)
    }
    private var elasticity: CGFloat {
        get {
            return UserDefaultsSingleton.sharedInstance.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.Elasticity) as? CGFloat ?? 1.0
        }
        set{
            UserDefaultsSingleton.sharedInstance.defaults!.set(
                newValue, forKey: UserDefaultsSingleton.Keys.Elasticity)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bricksCountSegmentedController.selectedSegmentIndex = (bricksCount / 10) - 1
        gravitySlider.value = Float(gravity)
        elasticitySlider.value = Float(elasticity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Game Settings"
//        }
//        return ""
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
