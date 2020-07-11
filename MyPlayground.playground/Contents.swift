//: Playground - noun: a place where people can play

import UIKit
import Foundation
import NetworkExtension
import Security
import Foundation
import CoreData


let manager = NEVPNManager.shared()
manager.isOnDemandEnabled = true
manager.loadFromPreferences { (error) -> Void in
    
    if error  == nil  {
        print("error is nill")
        let p = NEVPNProtocolIPSec()
        p.username = "zxxxxx"
        
        let array = NSMutableArray()
        
        p.passwordReference = KeychainMethods.getData("VPN_PASSWORD")
        p.serverAddress = "xxxxxxxx"
        p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
        //[self searchKeychainCopyMatching:@"PSK"];
        //p.sharedSecretReference = KeychainMethods().searchKeychainCopy(matching: "PSK")
        p.sharedSecretReference = KeychainMethods.getData("PSK")
        //p.sharedSecretReference = KeychainWrapper.standard.object(forKey:"vpn_secret") as? Data
        //p.sharedSecretReference = Data(String)
        p.localIdentifier = "xxxxx"
        p.remoteIdentifier = "xxxxx"
        p.useExtendedAuthentication = true
        p.disconnectOnSleep = false
        
        manager.protocolConfiguration = p
        manager.isEnabled = true
        manager.saveToPreferences(completionHandler: {(error) -> Void in
            
            if error == nil  {
                print("saved")
            }
            else {
                print (error.debugDescription)
            }
        })
    }
        
    else {
        print(error?.localizedDescription)
    }
}