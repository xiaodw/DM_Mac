//
//  DataBase.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/6.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject
-(void)setObject:(id)value forKey:(NSString*)key;
-(id)getObjectByKey:(NSString*)key;
@end
