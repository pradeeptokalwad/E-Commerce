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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadDataFromDB(_ sender: Any) {
        
        aryCategory = PTCoreDataManager.sharedInstance.fetchAllCategories()
        tblView.reloadData()
        print("All Category \(aryCategory)")
        
    }
    
    func fetchCategories(){
        
        Utility.showProgress()
        WebserviceInterface.getData(inputUrl: "https://stark-spire-93433.herokuapp.com/json", parameters: [:], completion: { response in
            
            if let apiJSON = response as? [String: Any]{
                
                let aryData = NSArray(array:apiJSON["categories"] as! [Any], copyItems: true) as NSArray
                
                for category in aryData {
                    PTCoreDataManager.sharedInstance.addCategory(dictParam: category as! NSDictionary)
                }
                DispatchQueue.main.async {
                    Utility.hideProgress()
                }
            }
        })
    }
    
    
    func numberOfSections(in tblView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return aryCategory.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell", for: indexPath) as? CategoryListTableViewCell
        cell?.configureCell(category: aryCategory[indexPath.row] as! Categories)
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    
}

