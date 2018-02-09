//
//  DataBase.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/6.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "LocalData.h"

@implementation LocalData

-(void)setObject:(id)value forKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:value forKey:key];
}

-(id)getObjectByKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:key];
}

@end
