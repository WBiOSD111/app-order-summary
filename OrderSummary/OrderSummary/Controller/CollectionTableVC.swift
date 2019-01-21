//
//  CollectionTableVC.swift
//  OrderSummary
//
//  Created by Alexandre Gravelle on 2019-01-16.
//  Copyright © 2019 Alexandre Gravelle. All rights reserved.
//

import UIKit
import FunctionalTableData

class CollectionTableVC: UITableViewController {
    
    private let functionalData = FunctionalTableData()
    private var collections: [Collection] = [] {
        didSet {
            render()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        functionalData.tableView = tableView
        title = "Collections"
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithHexString(hexStr: "#393e46")
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupTabBarUI()
        
        // Fetch all Collections
        CollectionService.instance.findAllCollections { (success) in
            if success {
                for collect in CollectionService.instance.collections {
                    self.collections.append(collect)
                }
            }
        }
    }
    
    func setupTabBarUI() {
        
        // Setting color to tab bar item and text
        self.tabBarController?.tabBar.tintColor = UIColor.darkGrayTheme
        
        // Setting icons to each tab bar item
        self.tabBarController?.tabBar.items?[0].setIcon(icon: .dripicon(.viewListLarge), size: nil, textColor: .lightGray)
        self.tabBarController?.tabBar.items?[1].setIcon(icon: .dripicon(.tags), size: nil, textColor: .lightGray)
        self.tabBarController?.tabBar.items?[2].setIcon(icon: .dripicon(.cart), size: nil, textColor: .lightGray)
        
    }
    
    private func render() {
        let rows: [CellConfigType] = collections.enumerated().map { (arg) -> CellConfigType in
            
            let (index, item) = arg
            return LabelCell(
                key: "id-\(index)",
                actions: CellActions(
                    selectionAction: { _ in
                        print("\(item) selected")
                        ProductService.instance.findAllCollects(collectionId: item.id) { (success) in
                            if success {
                                ProductService.instance.findAllProducts(productIds: ProductService.instance.collects, completion: { (success) in
                                    if success {
                                        self.performSegue(withIdentifier: "productListCollectsSegue", sender: nil)
                                    }
                                })
                            }
                        }
                        return .selected
                },
                    deselectionAction: { _ in
                        print("\(item) deselected")
                        return .deselected
                }),
                state: LabelState(text: item.title),
                cellUpdater: LabelState.updateView)
        }
        
        functionalData.renderAndDiff([
            TableSection(key: "section", rows: rows)
            ])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "productListCollectsSegue" {
            let productListVC = segue.destination as! ProductListTableVC
            productListVC.productListData = ProductService.instance.products
            
        }
    }

}
