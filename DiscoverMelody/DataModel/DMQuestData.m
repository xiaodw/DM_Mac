//
//  DMQuestData.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMQuestData.h"

@implementation DMQuestOptions
@end

@implementation DMQuestSingleData
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"options" : @"DMQuestOptions"
             };
}

@end

@implementation DMQuestData
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"list" : @"DMQuestSingleData"
             };
}
@end
