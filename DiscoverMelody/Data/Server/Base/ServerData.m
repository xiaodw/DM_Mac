//
//  ServerData.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/7.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "ServerData.h"
#import "DMRequestModel.h"

@interface ServerData()
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation ServerData
+ (DMRequestModel *_Nullable)sharedInstance {
    static DMRequestModel *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        //请求参数序列化类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //响应结果序列化类型
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //请求超时时间
        self.manager.requestSerializer.timeoutInterval = 15;
    }
    return self;
}


/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param url        地址
 *  @param method     请求类型
 *  @param parameters 请求参数
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)( NSError *error))failure {
    //请求的URL
    NSLog(@"Request path:%@",url);

    switch (method) {
        case DMHttpRequestGet: {
            [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            break;
        case DMHttpRequestPost: {
            
            [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            break;
        case DMHttpRequestDelete: {
            
            [self.manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            break;
        case DMHttpRequestPut: {
            
            [self.manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            break;
        default:
            break;
    }
}

-(void)cancleAllHttpRequestOperations {
    [self.manager.operationQueue cancelAllOperations];
}

@end
