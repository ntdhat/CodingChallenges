//
//  FiveDigitsFibonacciNumber.h
//  FacebookCodingChallenge
//
//  Created by admin on 1/29/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

#ifndef FiveDigitsFibonacciNumber_h
#define FiveDigitsFibonacciNumber_h

#import <Foundation/Foundation.h>

@interface FiveDigitsFibonacciNumber: NSObject

+(UInt32)last5DigitsAt:(UInt32)position;
+(NSString*)last5DigitsFibonacci:(UInt32)position;

@end

@implementation FiveDigitsFibonacciNumber

+(UInt32)last5DigitsAt:(UInt32)position {
    UInt32 returnedValue = 0;
    
    if (position >= 2) {
        UInt32 prev = 1, prevprev = 0;
        for (int i = 2; i <= position; i++) {
            returnedValue = (prev + prevprev) % 100000;
            prevprev = prev;
            prev = returnedValue;
        }
    } else {
        returnedValue = position;
    }
    
    return returnedValue;
}

+(NSString*)last5DigitsFibonacci:(UInt32)position {
    UInt32 last5Digits = [FiveDigitsFibonacciNumber last5DigitsAt:position];
    return position < 26 ? [NSString stringWithFormat:@"%d", last5Digits] : [NSString stringWithFormat:@"%05d", last5Digits];
}

@end

#endif /* FiveDigitsFibonacciNumber_h */
