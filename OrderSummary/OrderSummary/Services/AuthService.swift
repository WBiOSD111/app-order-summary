//
//  AuthService.swift
//  OrderSummary
//
//  Created by Alexandre Gravelle on 2019-01-09.
//  Copyright © 2019 Alexandre Gravelle. All rights reserved.
//

import Foundation

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var authToken: String {
        get {
            return defaults.string(forKey: ACCESS_TOKEN) ?? ACCESS_TOKEN
        }
        set {
            defaults.set(newValue, forKey: ACCESS_TOKEN)
        }
    }
    
}
