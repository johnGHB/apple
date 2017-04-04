//
//  ViewController.swift
//  vpn
//
//  Created by John Nguyen on 3/20/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit
import NetworkExtension
import Security
import Foundation

class ViewController: UIViewController {
    
    @IBAction func ConnectVPNbutton(_ sender: AnyObject) {
        ConnectLabel.text = "Connecting"
        
        let VPNmanager = NEVPNManager.shared()
        
        let VPNstatus = VPNmanager.connection.status
        
        if (VPNstatus == NEVPNStatus.connected) {
            VPNmanager.connection.stopVPNTunnel()
        } else {
            
            VPNmanager.loadFromPreferences { error in
                // setup the config:
                let username = "jnguyen"
                //let password = "awsvpn3620"
                let vpnhost = "ec2-52-40-232-14.us-west-2.compute.amazonaws.com"
                let p = NEVPNProtocolIPSec()
                p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
                p.serverAddress = vpnhost
                p.username = username
                
                let kcs = KeychainService()
                kcs.save(key: "SHARED", value: "MY_SHARED_KEY")
                kcs.save(key: "VPN_PASSWORD", value: "MY_PASSWORD")

                p.sharedSecretReference = kcs.load(key: "eEgRez3Yu")
                p.passwordReference = kcs.load(key: "awsvpn3620")

                p.useExtendedAuthentication = true
                p.disconnectOnSleep = true
                
                
                var rules = [NEOnDemandRule]()
                let rule = NEOnDemandRuleConnect()
                rule.interfaceTypeMatch = .any
                rules.append(rule)
                
                VPNmanager.localizedDescription = "VPNnow"
                VPNmanager.protocolConfiguration = p
                VPNmanager.onDemandRules = rules
                VPNmanager.isOnDemandEnabled = true
                VPNmanager.isEnabled = true
                VPNmanager.saveToPreferences { error in
                    guard error == nil else {
                        print("NEVPNManager.saveToPreferencesWithCompletionHandler failed: \(error!.localizedDescription)")
                        return
                    }
                    do {
                        try VPNmanager.connection.startVPNTunnel()
                        self.ConnectLabel.text = "Connected"
                    }
                    catch {
                        NSLog("error: Failed to start vpn: \(error)")
                    }
                }
            } //manager loadFromPreferencesWithCompletionHandler
        } //else

    }
    
    @IBOutlet var ConnectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    } //override func
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
} //Viewcontroller
