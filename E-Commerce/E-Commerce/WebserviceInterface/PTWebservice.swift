//
//  PTWebservice.swift
//  Demo
//
//  Created by webwerks on 11/10/17.
//  Copyright © 2017 PT. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


struct WebserviceInterface {
    
    static let nilValue = ""
    
    static func getData(inputUrl:String,parameters:[String:Any],completion:@escaping(_:Any)->Void){
        let url = URL(string: inputUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            if let JSON = response.result.value {
                completion(JSON)
            }
            else {
                completion(nilValue)
            }
        }
    }
}

struct   Utility {
    
    static  func showAlert(title : String,strMsg: String, viewController: UIViewController){
        let alert = UIAlertController(title: title , message: strMsg , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true , completion: nil)
    }
    
    static func showProgress() {
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading ...")
    }
    static func hideProgress() {
        
        SVProgressHUD.dismiss()
    }
    static func showSuccessMessage(string:String){
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        SVProgressHUD.showSuccess(withStatus: string)
    }
    static func showErrorMessage(string:String){
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        SVProgressHUD.showError(withStatus: string)
    }
    
}
