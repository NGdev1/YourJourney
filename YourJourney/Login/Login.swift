//
//  Login.swift
//  YourJourney
//
//  Created by Apple on 06.11.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var editingTextField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .interactive
        
        textFieldMail.delegate = self
        textFieldPassword.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: .UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var needToScrollToTextField = false
        
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            self.keyboardConstraint?.constant = 0
        } else {
            if self.keyboardConstraint?.constant == 0 {
                needToScrollToTextField = true
            }
            
            self.keyboardConstraint?.constant = endFrame.size.height
        }
        
        self.view.layoutIfNeeded()
        
        if needToScrollToTextField {
            if editingTextField != nil {
                textFieldDidBeginEditing(editingTextField!)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
        //scrollView.contentInset.bottom = textField.frame.height
        if scrollView.bounds.height < scrollView.contentSize.height {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: textField.center.y - 197), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldMail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            loginAction(self)
        }
        
        return true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let error = DataCheck.checkLoginInputs(textFieldMail.text!,
                                                  textFieldPassword.text!)
        {
            Utils.showError(error, viewController: self)
            return
        }
        
        SVProgressHUD.show()
        
        _ = APIService.shared().login(mail: textFieldMail.text!, password: textFieldPassword.text!, completionHandler: {(responce: (code: Int?, body: JSON?)?, error) in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                SVProgressHUD.showError(withStatus: "Ошибка")
                return
            }
            
            guard responce != nil else {
                SVProgressHUD.showError(withStatus: "Ошибка")
                return
            }
            
            if responce!.code == 0 {
                DataManager.set(
                    value: responce!.body!["access_token"].string!,
                    forKey: "token")
                
                DataManager.set(
                    value: responce!.body!["refresh_token"].string!,
                    forKey: "refresh_token")
                
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let nextVc = storyboard.instantiateInitialViewController()
                
                self.revealViewController().pushFrontViewController(nextVc, animated: true)
                
            } else if responce!.code == 10 {
                Utils.showError("Неверный email или пароль", viewController: self)
            } else {
                SVProgressHUD.showError(withStatus: "Ошибка")
                return
            }
        })
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let nextVc = storyboard.instantiateInitialViewController()
        
        self.navigationController?.pushViewController(nextVc!, animated: true)
    }
}
