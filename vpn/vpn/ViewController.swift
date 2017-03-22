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
        
        let manager = NEVPNManager.shared()
        
        let status = manager.connection.status;
        
        if (status == NEVPNStatusConnected) {
            manager.connection stopVPNTunnel;
        } else {
            
            [[NEVPNManager shared] loadFromPreferencesWithCompletionHandler:^(NSError *error) {
                if (error) {
                    NSLog(@"Load error: %@", error);
                }
                else {
                // No errors! The rest of your codes goes here...
                NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc] init];
                p.serverAddress = @"VPN SERVER ADDRESS";
                p.authenticationMethod = NEVPNIKEAuthenticationMethodCertificate;
                p.localIdentifier = @"Local identifier";
                p.remoteIdentifier = @"Remote identifier";
                p.useExtendedAuthentication = YES;
                p.identityData = [NSData dataWithBase64EncodedString:certBase64String];;
                p.identityDataPassword = @"identity password";
                p.disconnectOnSleep = NO;
                
                // Set protocol
                [[NEVPNManager sharedManager] setProtocol:p];
                
                // Set on demand
                NSMutableArray *rules = [[NSMutableArray alloc] init];
                NEOnDemandRuleConnect *connectRule = [NEOnDemandRuleConnect new];
                [rules addObject:connectRule];
                [[NEVPNManager sharedManager] setOnDemandRules:rules];
                
                // Set localized description
                [[NEVPNManager sharedManager] setLocalizedDescription:@"Description"];
                
                // Enable VPN
                [[NEVPNManager sharedManager] setEnabled:YES];
                
                // Save to preference
                [[NEVPNManager sharedManager] saveToPreferencesWithCompletionHandler: ^(NSError *error) {
                NSLog(@"Save VPN to preference complete");
                if (error) {
                NSLog(@"Save to preference error: %@", error);
                }
                }];
                }
                }];
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

