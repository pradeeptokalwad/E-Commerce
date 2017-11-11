//
//  ViewController.swift
//  Demo
//
//  Created by webwerks on 11/10/17.
//  Copyright © 2017 PT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!

    var aryCategory: NSArray = []
    var aryRanking: NSArray = []

    @IBOutlet weak var btnSegmnestControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aryCategory = PTCoreDataManager.sharedInstance.fetchAllCategories()
        aryRanking = PTCoreDataManager.sharedInstance.fetchAllRanking()

        if aryCategory.count == 0{
            fetchCategories()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadDataFromDB(_ sender: Any) {
        
        aryCategory = PTCoreDataManager.sharedInstance.fetchAllCategories()
        aryRanking = PTCoreDataManager.sharedInstance.fetchAllRanking()
        tblView.reloadData()
    }
    
    func fetchCategories(){
        
        Utility.showProgress()
        WebserviceInterface.getData(inputUrl: "https://stark-spire-93433.herokuapp.com/json", parameters: [:], completion: { response in
            
            if let apiJSON = response as? [String: Any]{
                
                let aryData = NSArray(array:apiJSON["categories"] as! [Any], copyItems: true) as NSArray
                
                self.aryRanking = NSArray(array:apiJSON["rankings"] as! [Any], copyItems: true) as NSArray

                for category in aryData {
                    PTCoreDataManager.sharedInstance.addCategory(dictParam: category as! NSDictionary)
                }
                for rankingProduct in self.aryRanking {
                    PTCoreDataManager.sharedInstance.rankingOfProducts(dictParam: rankingProduct as! NSDictionary)
                }
                DispatchQueue.main.async {
                    self.aryCategory = PTCoreDataManager.sharedInstance.fetchAllCategories()
                    Utility.hideProgress()
                    self.tblView.reloadData()
                }
            }
        })
    }
    
    
    func numberOfSections(in tblView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        if self.btnSegmnestControl.selectedSegmentIndex == 1 {
            return aryRanking.count
        }
        else {
            return aryCategory.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell", for: indexPath) as? CategoryListTableViewCell
        
        if self.btnSegmnestControl.selectedSegmentIndex == 1 {
            cell?.configureRankingCell(strTitle: ((aryRanking[indexPath.row]) as! NSDictionary).value(forKey: "ranking") as! NSString)
        }else {
            cell?.configureCell(category: aryCategory[indexPath.row] as! Categories)
        }
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let productCollectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductCollectionViewController") as? ProductCollectionViewController ?? ProductCollectionViewController()
        
        if self.btnSegmnestControl.selectedSegmentIndex == 1 {
            
            let cellSelected = tableView.cellForRow(at: indexPath) as! CategoryListTableViewCell
            
            if cellSelected.lblCategoryTitle.text != nil {
                let ranking = cellSelected.lblCategoryTitle.text! as NSString
                let aryProductList = PTCoreDataManager.sharedInstance.fetchRankingWiseData(strRanking: ranking)
                productCollectionViewController.setupDataAdneloadTable(aryProd: aryProductList)
            }
        }else {
            let aryProductList = ((aryCategory[indexPath.row] as! Categories).productlist?.allObjects) as? NSArray ?? []
            productCollectionViewController.setupDataAdneloadTable(aryProd: aryProductList)
        }
        self.navigationController?.pushViewController(productCollectionViewController, animated: true);
    }
    
    
    @IBAction func btnSegmnestedTapped(_ sender: UISegmentedControl) {
        
        self.tblView.reloadData()
    }
    
}

