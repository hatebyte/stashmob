//
//  PrivatePhone.m
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

#import "PrivatePhone.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@implementation PrivatePhone
extern NSString* CTSettingCopyMyPhoneNumber();

+ (NSString *) phoneNumber {
    NSString *phone = CTSettingCopyMyPhoneNumber();
    return phone;
}

@end
