//
//  Location.m
//  ShakespeareanLanguage
//
//  Created by Simon Lam on 3/9/19.
//  Copyright © 2019 Simon Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
@implementation Location

-(id) initWithPosition: (int) p onLine:(int) l ofSonnet: (int) s {
    self = [super init];
    if (self){
        self.sonnetLine = l;
        self.sonnetNumber = s;
        self.wordPosition = p;
    }
    return self;
}

@end
