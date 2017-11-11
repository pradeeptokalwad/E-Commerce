//
//  CategoryListTableViewCell.swift
//  Demo
//
//  Created by webwerks on 11/11/17.
//  Copyright © 2017 PT. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblProductCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(category: Categories) {
        self.lblCategoryTitle.text = category.parentCatName
        self.lblProductCount.text = String(describing: category.productlist!.count)
    }
    func configureRankingCell(strTitle: NSString) {
        self.lblCategoryTitle.text = strTitle as String
        self.lblProductCount.text = ""
    }


}
