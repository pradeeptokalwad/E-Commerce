//
//  ProductDetailTableViewController.swift
//  E-Commerce
//
//  Created by webwerks on 11/11/17.
//  Copyright © 2017 PT. All rights reserved.
//

import UIKit

class ProductDetailTableViewController: UITableViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    

    var productDetails: Products = Products()
    var aryPicker: NSArray = []
    var selectedRow: NSInteger = 0
    
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblPriceTax: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductTax: UILabel!

    @IBOutlet var tlbDone: UIToolbar!
    @IBOutlet var pickerColorAndSizes: UIPickerView?
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var txtFieldSizes: UITextField!
    @IBOutlet weak var txtFieldQty: UITextField!
    @IBOutlet weak var txtFieldColor: UITextField!
    
    var isSizeSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aryPicker = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        // Connect data:
        self.pickerColorAndSizes?.delegate = self
        self.pickerColorAndSizes?.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func configureProductDetails(product: Products) {
        productDetails = product;
        
        tableView.reloadData()
        
        let variant = (product.variants?.allObjects as NSArray? ?? []).firstObject as! Variants
        priceUpdateAsPerQty(variant: variant, qty: 1)
        
        self.lblProductTitle.text = product.productName
        let  productURL = product.productImageURL as String?
        
        
        self.lblProductTax.text = "(inclusive of \((String(format:"%.0f", product.productTaxValue)))% \(String(describing: product.productTaxName!)))".lowercased()

        guard productURL != nil else { /* Handle nil case */ return }
        imgView.sd_setImage(with: URL(string: productURL!), placeholderImage: UIImage(named: "placeholder.png"))
    }
    
    
    func priceUpdateAsPerQty(variant: Variants, qty: NSInteger) {
        
        let priceValue = variant.price as Float? ?? 0
        var taxPriceValue = Float(productDetails.productTaxValue) as Float? ?? 0
        
        guard priceValue != 0 else { /* Handle nil case */ return }
        
        var totalPrice = priceValue as Float
        
        if taxPriceValue != 0{
            taxPriceValue = (Float(productDetails.productTaxValue)/100)*priceValue
            totalPrice = priceValue + taxPriceValue
        }
        
        
        if self.lblPriceTax != nil {
            self.lblPriceTax.text = "Rs." + String((Double(totalPrice) * Double(qty)))
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAddToCartTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
        Utility.showSuccessMessage(string: "Product Added to cart")
    }
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        if txtFieldQty.isFirstResponder {
            
            if (txtFieldQty.text?.isEmpty)! {
                Utility.showAlert(title: "Please enter Qty More than zero", strMsg: "", viewController: self)
            }else {
                priceUpdateAsPerQty(variant: (aryPicker[selectedRow] as? Variants)!, qty: Int(txtFieldQty.text!)!)
            }
        }

        self.view.endEditing(true)
    }
    
    //Textfield delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = tlbDone;
        
        if txtFieldQty.isEqual(textField){
            aryPicker = (productDetails.variants?.allObjects as NSArray? ?? []) as! [Variants] as NSArray
        }else {
            selectedRow = 0
            
            aryPicker = (removeDuplicateRecords(arrayOfDicts: (productDetails.variants?.allObjects as NSArray? ?? []) as! [Variants]) as NSArray)
            textField.inputView = pickerColorAndSizes;
            pickerColorAndSizes?.reloadAllComponents()
        }
    }
    
    
    
    func removeDuplicateRecords(arrayOfDicts: [Variants]) -> [Variants]
    {
        var aryUniqueue: [String:Variants] = [:]
        for dict in arrayOfDicts
        {
            if txtFieldColor.isFirstResponder {
                if let name = dict.color
                {
                    aryUniqueue[name] = dict
                }
            }else if txtFieldSizes.isFirstResponder {
                let strSize = String(describing: dict.size)
                if dict.size != 0
                {
                    aryUniqueue[strSize] = dict
                }
            }
        }
        
        return Array(aryUniqueue.values.map{ $0 })
    }
    
    //Picker delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return aryPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtFieldColor.isFirstResponder {
        return (aryPicker[row] as? Variants)?.color
        }else if txtFieldSizes.isFirstResponder {
            return  String(format: "%.0f", ((aryPicker[row] as? Variants)?.size)!)
        }else {
            return  String(describing: row+1)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        selectedRow = row;
        
        if txtFieldColor.isFirstResponder {
            txtFieldColor.text = (aryPicker[row] as? Variants)?.color
        }else if txtFieldSizes.isFirstResponder {
            txtFieldSizes.text = String(format: "%.0f", ((aryPicker[row] as? Variants)?.size)!)
        }else {
            txtFieldQty.text = String(describing: row+1)
        }
    }
}


