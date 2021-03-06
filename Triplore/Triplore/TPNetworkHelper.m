//
//  TPNetworkHelper.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNetworkHelper.h"
#import "AFNetworking.h"
#import "TPVideoModel.h"

static NSString *ALL_URL = @"http://iface.qiyi.com/openapi/batch/channel";
static NSString *SEARCH_URL = @"http://iface.qiyi.com/openapi/realtime/search";

@implementation TPNetworkHelper

+ (void)fetchAllVideosWithBlock:(void(^)(NSArray<TPVideoModel *> *videos, NSError *error))completionBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"text/html",
                                                             @"application/json",
                                                             nil];
        
        NSDate *datenow =[NSDate date];//现在时间,你可以输出来看下是什么格式
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        
        NSInteger interval = [zone secondsFromGMTForDate:datenow];
        
        NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        timeSp = [timeSp stringByAppendingString:@"000"];
        
        NSDictionary *dict = @{
                               @"type" : @"detail",
                               @"channel_name" : @"旅游",
                               @"mode" : @(11),
                               @"is_purchase" : @(0),
                               @"page_size" : @(30),
                               @"version" : @(7.5),
                               @"app_k" : @"f0f6c3ee5709615310c0f053dc9c65f2",
                               @"app_v" : @(8.4),
                               @"app_t" : @(0),
                               @"platform_id" : @(12),
                               @"dev_os" : @(10.3),
                               @"dev_ua" : @"iPhone9,3",
                               @"dev_hw" : @"%7B%22cpu%22%3A0%2C%22gpu%22%3A%22%22%2C%22mem%22%3A%2250.4MB%22%7D",
                               @"net_sts" : @(1),
                               @"scrn_sts" : @(1),
                               @"scrn_res" : @"1334*750",
                               @"scrn_dpi" : @(153600),
                               @"qyid" : @"87390BD2-DACE-497B-9CD4-2FD14354B2A4",
                               @"secure_v" : @(1),
                               @"secure_p" : @"iPhone",
                               @"core" : @(1),
                               @"req_sn" : timeSp,
                               @"req_times" : @(5)
                               };
        
        [manager GET:ALL_URL
          parameters:dict
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (completionBlock){
                         NSDictionary *dict = (NSDictionary *)responseObject;
                         
                         if([dict[@"code"] integerValue] != 100000){
                             completionBlock(nil, nil);
                         }
                         
                         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
                         for(NSDictionary *subDict in dict[@"data"][@"video_list"]){
                             TPVideoModel *video = [[TPVideoModel alloc] initWithDict:subDict];
                             [resultArr addObject:video];
                         }
                         
                         NSLog(@"All Count: %lu", (unsigned long)resultArr.count);
                         
                         completionBlock([NSArray arrayWithArray:resultArr], nil);
                     }
                     
                 });
                 
             }
             failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
                 if (completionBlock){
                     completionBlock(nil, error);
                 }
             }];
    });
}

+ (void)fetchVideosByKeywords:(NSArray *)keywords withSize:(NSUInteger)size inPage:(NSUInteger)pageNum withBlock:(void(^)(NSArray<TPVideoModel *> * videos, NSError * error))completionBlock{
    NSString *searchString = @"";
    for (NSString *s in keywords){
        searchString = [searchString stringByAppendingString:s];
        if(s != [keywords lastObject]){
            searchString = [searchString stringByAppendingString:@","];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"text/html",
                                                             @"application/json",
                                                             nil];
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
        NSDate *localeDate = [[NSDate date] dateByAddingTimeInterval:interval];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        timeSp = [timeSp stringByAppendingString:@"000"];
        
        NSDictionary *dict = @{
                               @"key" : searchString,
                               @"from" : @"mobile_list",
                               @"page_size" : @(size),
                               @"pg_num" : @(pageNum),
                               @"version" : @(7.5),
                               @"app_k" : @"f0f6c3ee5709615310c0f053dc9c65f2",
                               @"app_v" : @(8.4),
                               @"app_t" : @(0),
                               @"platform_id" : @(12),
                               @"dev_os" : @(10.3),
                               @"dev_ua" : @"iPhone9,3",
                               @"dev_hw" : @"%7B%22cpu%22%3A0%2C%22gpu%22%3A%22%22%2C%22mem%22%3A%2250.4MB%22%7D",
                               @"net_sts" : @(1),
                               @"scrn_sts" : @(1),
                               @"scrn_res" : @"1334*750",
                               @"scrn_dpi" : @(153600),
                               @"qyid" : @"87390BD2-DACE-497B-9CD4-2FD14354B2A4",
                               @"secure_v" : @(1),
                               @"secure_p" : @"iPhone",
                               @"core" : @(1),
                               @"req_sn" : timeSp,
                               @"req_times" : @(5)
                               };
        
        [manager GET:SEARCH_URL
          parameters:dict
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                    
                     if (completionBlock){
                         if([dict[@"code"] integerValue] != 100000){
                             completionBlock(nil, nil);
                         }
                         
                         NSDictionary *dict = (NSDictionary *)responseObject;
                         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
                         for(NSDictionary *subDict in dict[@"data"]){
                             if([subDict[@"title"] containsString:keywords[0]]){
                                 TPVideoModel *video = [[TPVideoModel alloc] initWithDict:subDict];
                                 [resultArr addObject:video];
                             }
                         }
                         completionBlock([NSArray arrayWithArray:resultArr], nil);
                     }
                     
                 });

             }
             failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
                 if (completionBlock){
                     completionBlock(nil, error);
                 }
             }];

    });
}

+ (void)fetchVideosInAlbum:(NSString *)albumName andAlbumID:(NSString *)albumID withBlock:(void(^)(NSArray<TPVideoModel *> *videos, NSError *error))completionBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"text/html",
                                                             @"application/json",
                                                             nil];
        
        NSDictionary *dict = @{
                               @"key" : albumName,
                               @"from" : @"mobile_list",
                               @"page_size" : @(300),   //这个……暂时先这样
                               @"version" : @(7.5),
                               @"app_k" : @"f0f6c3ee5709615310c0f053dc9c65f2",
                               @"app_v" : @(8.4),
                               @"app_t" : @(0),
                               @"platform_id" : @(12),
                               @"dev_os" : @(10.3),
                               @"dev_ua" : @"iPhone9,3",
                               @"dev_hw" : @"%7B%22cpu%22%3A0%2C%22gpu%22%3A%22%22%2C%22mem%22%3A%2250.4MB%22%7D",
                               @"net_sts" : @(1),
                               @"scrn_sts" : @(1),
                               @"scrn_res" : @"1334*750",
                               @"scrn_dpi" : @(153600),
                               @"qyid" : @"87390BD2-DACE-497B-9CD4-2FD14354B2A4",
                               @"secure_v" : @(1),
                               @"secure_p" : @"iPhone",
                               @"core" : @(1),
                               @"req_sn" : @"1493946331320",
                               @"req_times" : @(5)
                               };
        
        [manager GET:SEARCH_URL
          parameters:dict
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (completionBlock){
                         if([dict[@"code"] integerValue] != 100000){
                             completionBlock(nil, nil);
                         }
                         
                         NSDictionary *dict = (NSDictionary *)responseObject;
                         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
                         for(NSDictionary *subDict in dict[@"data"]){
                             if([subDict[@"a_id"] isEqualToString:albumID]
                                && [subDict[@"p_type"] integerValue] == 1){
                                 TPVideoModel *video = [[TPVideoModel alloc] initWithDict:subDict];
                                 [resultArr addObject:video];
                             }
                         }
                         
                         //按 videoid 大小排序
                         [resultArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                             TPVideoModel *v1 = (TPVideoModel *)obj1;
                             TPVideoModel *v2 = (TPVideoModel *)obj2;
                             return v1.videoid <= v2.videoid ? NSOrderedAscending : NSOrderedDescending;
                         }];
                         
                         completionBlock([NSArray arrayWithArray:resultArr], nil);
                     }
                     
                 });
                 
             }
             failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
                 if (completionBlock){
                     completionBlock(nil, error);
                 }
             }];
        
    });
}

+ (NSString *)getURLString:(NSString *)str{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
