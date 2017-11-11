//
//  ProductCollectionViewCell.swift
//  E-Commerce
//
//  Created by webwerks on 11/11/17.
//  Copyright © 2017 PT. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblPriceTax: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductTax: UILabel!

    func configureCell(product: Products) {
        
        let variant = (product.variants?.allObjects as NSArray? ?? []).firstObject as! Variants
        let priceValue = variant.price as Float? ?? 0
//        var taxPriceValue = Float(product.productTaxValue) as Float? ?? 0

        
        guard priceValue != 0 else { /* Handle nil case */ return }

        self.lblPriceTax.text = "Rs." + String(priceValue)
        
//        if taxPriceValue != 0{
//            taxPriceValue = (Float(product.productTaxValue)/100)*priceValue
//            self.lblProductTax.text = "+ \(String(describing: product.productTaxName!)) = " +  String(taxPriceValue)
//        }
        
        self.lblProductTitle.text = product.productName
        
        let  productURL = product.productImageURL as String?
        
        guard productURL != nil else { /* Handle nil case */ return }
        imgView.sd_setImage(with: URL(string: productURL!), placeholderImage: UIImage(named: "placeholder.png"))
        
    }
    
}
