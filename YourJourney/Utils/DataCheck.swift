//
//  DataCheck.swift
//  YourJourney
//
//  Created by Apple on 13.12.2017.
//  Copyright © 2017 md. All rights reserved.
//


class DataCheck {
    
    static func checkRegisterInputs(
                                  _ name : String,
                                  _ email : String,
                                  _ password : String,
                                  _ passwordConfirming : String) -> String? {
        
        if name.isEmpty {
            return "Введите имя"
        } else if !validateName(name){
            return "Введите имя в правильном формате"
        }
        
        if email.isEmpty {
            return "Введите email"
        } else if !validateEmail(email){
            return "Введите email в правильном формате"
        }
        
        if password != passwordConfirming {
            return "Пароли не совпадают"
        }
        
        if password.length < 8 {
            return "Длина пароля должна быть больше 8"
        }
        
        return nil
    }
    
    static func checkLoginInputs( _ email : String,
                                  _ password : String) -> String? {
        if email.isEmpty {
            return "Введите email"
        } else if !validateEmail(email){
            return "Введите email в правильном формате"
        }
        
        if password.isEmpty {
            return "Введите пароль"
        }
        
        return nil
    }
    
    private static func validateName(_ candidate: String) -> Bool {
        let regex = "^[a-zA-Zа-яА-Я]+(([',. -][a-zA-ZА-Яа-я ])?[a-zA-Zа-яА-Я]*)*$"
        
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
        
        return isValid
    }
    
    private static func validateEmail(_ candidate: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
        
        return isValid
    }
}
