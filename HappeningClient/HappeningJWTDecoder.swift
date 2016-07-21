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
            print("inside the do block")
            let jwt = try decode(jwtString)
            print("jwt: \(jwt)")
            print("body: \(jwt.body)")
            if let j = jwt.subject {
                print("jwt.subject is not nil. subject: \(jwt.subject)")
                userId = j
            }
        }
        catch let error as NSError {
            error.localizedDescription
            print("error: \(error.localizedDescription)")
        }
        return userId
    }
}
