//
//  HappeningJWTDecoder.swift
//  HappeningClient
//
//  Created by Brandon Manson on 7/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

import Foundation
import JWTDecode

class HappeningJWTDecoder: NSObject {
    var userId = Int();
    
    func returnUserId(jwtString: String) -> Int {
        do {
            let jwt = try decode(jwtString)
            if let j = jwt.subject {
                userId = j
            }
        }
        catch let error as NSError {
            error.localizedDescription
            print("error: \(error.localizedDescription)")
        }
        return userId
    }
    
    func isExpired(jwtString: String) -> Bool {
        var expirationStatus = Bool();
        do {
            let jwt = try decode(jwtString)
            expirationStatus = jwt.expired
        } catch let error as NSError {
            error.localizedDescription
            print("error: \(error.localizedDescription)")
        }
        return expirationStatus
    }
}
