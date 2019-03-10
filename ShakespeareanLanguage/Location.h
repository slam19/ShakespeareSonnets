//
//  Location.h
//  ShakespeareanLanguage
//
//  Created by Simon Lam on 3/9/19.
//  Copyright © 2019 Simon Lam. All rights reserved.
//

#ifndef Location_h
#define Location_h
@interface Location<ObjectType>: NSObject

@property int sonnetLine;
@property int sonnetNumber;
@property int wordPosition;

-(id) initWithPosition: (int) p onLine:(int) l ofSonnet: (int) s ;

@end

#endif /* Location_h */
