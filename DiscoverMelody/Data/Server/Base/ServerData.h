//
//  ServerData.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/7.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

enum HttpRequestType {
    HttpRequestGet = 0,
    HttpRequestPost,
    HttpRequestDelete,
    HttpRequestPut,
};

@interface ServerData : NSObject

-(void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)( NSError *error))failure;
-(void)cancleAllHttpRequestOperations;

@end
