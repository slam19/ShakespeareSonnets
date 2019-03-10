//
//  WordNode.m
//  ShakespeareanLanguage
//
//  Created by Simon Lam on 3/9/19.
//  Copyright © 2019 Simon Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordNode.h"
#import "Location.h"

@implementation WordNode

-(id) initWithWord:(NSString *)w AtPosition: (int)p onLine: (int) l ofSonnet:(int)s {
    self = [super init];
    if (self){
        self.word = w;
        Location * loc= [[Location alloc] initWithPosition:p onLine:l ofSonnet:s];
        self.locations = [[NSMutableArray alloc]init];
        [self.locations addObject:loc];
    }
    return self;
}

-(id) initEmptyWord{
    self = [super init];
    if (self){
        self.word = @"";
        self.locations = nil;
    }
    return self;
}


@end
