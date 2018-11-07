//
//  ProductTagsViewController.swift
//  OrderSummary
//
//  Created by Alexandre Gravelle on 2018-09-19.
//  Copyright © 2018 Alexandre Gravelle. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftIcons

class ProductTagsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    @IBOutlet var productTagsCollectionView: UICollectionView!
    
    var productData = [Product]()
    
    var dataDictionary = [String: [Product]]()
    var dataSectionTitles = [String]()
    
    let loadingView = UIView()
    let loadingLabel = UILabel()
    let spinner = UIActivityIndicatorView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup for Navigation UI
        setupNavigationUI()
        
        // Setup for CollectionView UI
        setupCollectionViewUI()
        
        // Setup for TabBar UI
        setupTabBarUI()
        
        // Setup Loading Screen for fetching data
        setLoadingScreen()
        
        //Fetching data from the Shopify API
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationUI() {
        // Setup navigation
        self.navigationItem.title = "Products"
        
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithHexString(hexStr: "#393e46")
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupCollectionViewUI() {
        let widthCell = (self.view.frame.width-20)
        let heightCell = self.tabBarController?.tabBar.frame.size.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: widthCell, height: heightCell!)
        productTagsCollectionView.setCollectionViewLayout(layout, animated: true)
        collectionView?.backgroundColor = UIColor.darkGrayTheme
    }
    
    func setupTabBarUI() {
        
        // Setting color to tab bar item and text
        self.tabBarController?.tabBar.tintColor = UIColor.darkGrayTheme
        
        // Setting icons to each tab bar item
        self.tabBarController?.tabBar.items?[0].setIcon(icon: .dripicon(.tags), size: nil, textColor: .lightGray)
        self.tabBarController?.tabBar.items?[1].setIcon(icon: .dripicon(.cart), size: nil, textColor: .lightGray)
        
    }
    
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = ((self.view.frame.width) / 2) - (width / 2)
        let y = ((self.view.frame.height) / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .white
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        self.view.addSubview(loadingView)
    }
    
    private func removeLoadingScreen() {
        self.navigationItem.leftBarButtonItem?.isEnabled = true;
        self.navigationItem.rightBarButtonItem?.isEnabled = true;
        self.view.isUserInteractionEnabled = true
        
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
    
    func fetchData() {
        Alamofire.request("https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                _ = JSON(value)["products"].array!.map { json in
                    let productId = json["id"].int
                    let productTitle = json["title"].description
                    let productSubTitle = json["body_html"].description
                    let productTags = json["tags"].description
                    let productVariants = json["variants"].array
                    let productImageURL = json["image"]["src"].description
                    
                    // Calculate total inventory by looking through each variant
                    var productInventory: Int = 0
                    
                    for variant in productVariants! {
                        
                        productInventory += variant["inventory_quantity"].int!
                        
                    }
                    
                    // Convert the tags into a String Array
                    let productTagsArray = productTags.components(separatedBy: ", ").filter {!$0.isEmpty}
                    
                    let product = Product.init(productId: productId!, productTitle: productTitle, productSubTitle: productSubTitle, productTags: productTagsArray, productVariants: productVariants!, productInventory: productInventory, productImageURL: productImageURL)
                    self.productData.append(product)
                    
                    
                }

                self.sort()

                self.removeLoadingScreen()
                self.collectionView?.reloadData()
        }
    }
    
    func sort() {
        self.dataDictionary.removeAll()
        self.dataSectionTitles.removeAll()
        
        // Create the dictionary product tag as keys.
        for d in self.productData {
            let dataKeys = d.productTags
            
            for dataKey in dataKeys {
                
                if var dataValues = self.dataDictionary[dataKey] {
                    dataValues.append(d)
                    self.dataDictionary[dataKey] = dataValues
                } else {
                    self.dataDictionary[dataKey] = [d]
                }
                
            }
            
        }
            
        // Create Array of all product tags
        self.dataSectionTitles = [String](self.dataDictionary.keys)
        self.dataSectionTitles = self.dataSectionTitles.sorted(by: { $0 < $1 })
        
        
        for d in self.dataDictionary {
            let dataKey = d.key
            let dataValues = self.dataDictionary[dataKey]
            self.dataDictionary[dataKey] = dataValues?.sorted(by: { $0.productId > $1.productId })
        }
        
    }
    
    // MARK: - UICollectionView Delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSectionTitles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        myCell.backgroundColor = UIColor.white
        myCell.layer.cornerRadius = 19.0
        myCell.tag = indexPath.row
        
        let label = myCell.viewWithTag(101) as! UILabel
        label.textColor = UIColor.darkGrayTheme
        label.text = dataSectionTitles[indexPath.row]
        label.textAlignment = .center
        
        return myCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "productListSegue" {
            let productListVC = segue.destination as! ProductListTableViewController
            if let cell = sender as? UICollectionViewCell
            {
                let indexPath = cell.tag
                let productTag = dataSectionTitles[(indexPath)]
                productListVC.productListData = dataDictionary[productTag]!
            }
        }
    }

}
