//
//  ProductCollectionViewController.swift
//  E-Commerce
//
//  Created by webwerks on 11/11/17.
//  Copyright © 2017 PT. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductCollectionViewCell"

class ProductCollectionViewController: UICollectionViewController {

    var aryProduct: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public func setupDataAdneloadTable(aryProd: NSArray) {
        aryProduct = aryProd
        self.collectionView?.reloadData()
        
        if aryProd.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                Utility.showAlert(title: "Products are not avaible in this category", strMsg: "", viewController: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryProduct.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        cell.configureCell(product: aryProduct[indexPath.row] as! Products)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let productDetailTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailTableViewController") as? ProductDetailTableViewController ?? ProductDetailTableViewController()
        self.navigationController?.pushViewController(productDetailTableViewController, animated: true);

        productDetailTableViewController.configureProductDetails(product: aryProduct[indexPath.row] as! Products)
    }
}
