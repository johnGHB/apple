//
//  vpnmanager.swift
//  ipsecvpn
//
//  Created by John Nguyen on 4/9/17.
//  Copyright © 2017 Emergnz. All rights reserved.
//

import NetworkExtension


class VPN {
    
    let vpnManager = NEVPNManager.shared();
    var vpnlock:Bool = false
    
    private var vpnLoadHandler: (Error?) -> Void { return
    { (error:Error?) in
        if ((error) != nil) {
            print("Could not load VPN Configurations")
            return;
        }
        let p = NEVPNProtocolIPSec()
        p.username = "jnguyen"
        p.serverAddress = "ec2-52-40-232-14.us-west-2.compute.amazonaws.com"
        p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
        
        let kcs = KeychainService();
        kcs.save(key: "SHARED", value: "11093620")
        kcs.save(key: "VPN_PASSWORD", value: "awsvpn3620")
        p.sharedSecretReference = kcs.load(key: "SHARED")
        p.passwordReference = kcs.load(key: "VPN_PASSWORD")
            p.useExtendedAuthentication = true
            p.disconnectOnSleep = false
            self.vpnManager.protocolConfiguration = p
            self.vpnManager.localizedDescription = "IPsecvpn"
            self.vpnManager.isEnabled = true
            self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
        } }
    
    private var vpnSaveHandler: (Error?) -> Void { return
    { (error:Error?) in
        if (error != nil) {
            print("Could not save VPN Configurations")
            return
        } else {
            do {
                try self.vpnManager.connection.startVPNTunnel()
            } catch let error {
                print("Error starting VPN Connection \(error.localizedDescription)");
            }
        }
        }
        self.vpnlock = false
    }

public func connectVPN() {
    //For no known reason the process of saving/loading the VPN configurations fails.On the 2nd time it works
    do {
        try self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
    } catch let error {
        print("Could not start VPN Connection: \(error.localizedDescription)" )
    }
}

public func disconnectVPN() ->Void {
    self.vpnManager.connection.stopVPNTunnel()
}
}
