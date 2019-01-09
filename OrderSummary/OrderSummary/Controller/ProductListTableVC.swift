//
//  ProductListViewTableViewController.swift
//  OrderSummary
//
//  Created by Alexandre Gravelle on 2018-09-21.
//  Copyright © 2018 Alexandre Gravelle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProductListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productSubtitleLabel: UILabel!
    @IBOutlet weak var productInventoryLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    
}

class ProductListTableVC: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productSubTitleLabel: UILabel!
    @IBOutlet weak var productInventoryLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var productListData = [Product]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Setup tabbar
        setupTabBarUI()
        
        // Remove extra empty tableview cells
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabBarUI() {
        
        // Setting color to tab bar item and text
        self.tabBarController?.tabBar.tintColor = UIColor.darkGrayTheme
        
        // Setting icons to each tab bar item
        self.tabBarController?.tabBar.items?[0].setIcon(icon: .dripicon(.tags), size: nil, textColor: .lightGray)
        self.tabBarController?.tabBar.items?[1].setIcon(icon: .dripicon(.cart), size: nil, textColor: .lightGray)
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productListData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 123  //Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productListCell", for: indexPath) as! ProductListTableViewCell
        
        // Configure the cell...
        cell.productTitleLabel.text = productListData[indexPath.row].productTitle
        cell.productSubtitleLabel.text = productListData[indexPath.row].productSubTitle
        cell.productInventoryLabel.text = "Inventory: " + String(productListData[indexPath.row].productInventory)
        
        // Fetch image cell
        fetchImage(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchImage(cell: ProductListTableViewCell, indexPath: IndexPath) {

        Alamofire.request(productListData[indexPath.row].productImageURL).responseImage { response in
            
            if let image = response.result.value {
                cell.productImage.image = image
            }
        }
        
    }
    
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
