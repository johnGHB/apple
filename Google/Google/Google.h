//
//  Google.h
//  Google
//
//  Created by John Nguyen on 1/4/19.
//  Copyright © 2019 Emergnz. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Google : AMBundleAction

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
