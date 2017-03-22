//
//  ViewController.swift
//  vpn
//
//  Created by John Nguyen on 3/20/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let VPNmanager = NEVPNManager.shared()
        
        let VPNstatus = VPNmanager.connection.status
        //let status:NEVPNStatus
        
        let password = ""
        let username = ""
        let hostname = ""
        
        if (VPNstatus == NEVPNStatus.connected) {
            VPNmanager.connection.stopVPNTunnel()
        } else {
            
            VPNmanager.loadFromPreferences { error in
                // setup the config:
                let password = password
                let vpnhost = hostname
                let p = NEVPNProtocolIKEv2()
                p.username = username
                p.localIdentifier = username
                p.serverAddress = vpnhost
                p.remoteIdentifier = vpnhost
                p.authenticationMethod = .none
                p.passwordReference = password
                p.useExtendedAuthentication = true
                p.serverCertificateIssuerCommonName = vpnhost
                p.disconnectOnSleep = false
                
                
                var rules = [NEOnDemandRule]()
                let rule = NEOnDemandRuleConnect()
                rule.interfaceTypeMatch = .any
                rules.append(rule)
                
                VPNmanager.localizedDescription = "My VPN"
                VPNmanager.protocolConfiguration = p
                VPNmanager.onDemandRules = rules
                VPNmanager.isOnDemandEnabled = true
                VPNmanager.isEnabled = true
                VPNmanager.saveToPreferences { error in
                    guard error == nil else {
                        print("NEVPNManager.saveToPreferencesWithCompletionHandler failed: \(error!.localizedDescription)")
                        return
                    }
                    VPNmanager.connection.startVPNTunnel()
                }
            } //manager loadFromPreferencesWithCompletionHandler
        } //else
        
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
