//
//  TVOut.m
//  BAKiosk
//
//  Created by Eirik Eikås on 20.05.15.
//  Copyright (c) 2015 Evil Corp ENK. All rights reserved.
//

#import "TVOut.h"

@implementation TVOut

+ (TVOut *)sharedInstance {
    static TVOut *sharedInstance;
    @synchronized (self) {
        if (!sharedInstance) {
            sharedInstance = [[TVOut alloc] init];
        }
        return sharedInstance;
    }
}

- (void) startExternal {
    
}

@end
