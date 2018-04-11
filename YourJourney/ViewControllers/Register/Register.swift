//
//  Register.swift
//  YourJourney
//
//  Created by Apple on 05.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class Register: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPasswordConfirm: UITextField!
    
    var editingTextField : UITextField?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldName.delegate = self
        textFieldMail.delegate = self
        textFieldPassword.delegate = self
        textFieldPasswordConfirm.delegate = self
        
        scrollView.keyboardDismissMode = .interactive
        
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
        if textField == textFieldName {
            textFieldMail.becomeFirstResponder()
        } else if textField == textFieldMail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldPasswordConfirm.becomeFirstResponder()
        } else {
            doneAction(self)
        }
        
        return true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if let error = DataCheck.checkRegisterInputs(textFieldName.text!,
                                                     textFieldMail.text!,
                                                     textFieldPassword.text!,
                                                     textFieldPasswordConfirm.text!)
        {
            self.showError(error)
            return
        }
        
        SVProgressHUD.show()
        
        _ = APIService.shared().register(name: textFieldName.text!,
                                         mail: textFieldMail.text!,
                                         password: textFieldPassword.text!, completionHandler: {(responce: (code: Int?, body: JSON?)?, error) in

            SVProgressHUD.dismiss()
            
            if error != nil {
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
            } else if responce!.code == 14 {
                self.showError("Пользователь с таким email уже существует!")
            } else {
                SVProgressHUD.showError(withStatus: "Ошибка")
                return
            }
        })
    }
}
