//
//  ServiceHelper_AF3.m
//  SaruPayPOS
//
//  Created by Mirza Zuhaib Beg on 9/21/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ServiceHelper_AF3.h"

@implementation ServiceHelper_AF3

static ServiceHelper_AF3 * serviceHelper = nil;

#pragma mark - Initialization Methods

+(id)instance {
    
    @synchronized(self) {
        
        if(!serviceHelper)
            serviceHelper = [[ServiceHelper_AF3 alloc] init];
        serviceHelper.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
        [serviceHelper.manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
        [serviceHelper.manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
        
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"servicelistingadmin", @"@1!2@3#QWER#"];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        [serviceHelper.manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    
    return serviceHelper;
}

-(void)makeWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock{
    
    NSLog(@"getJSONFromDict %@",[SLUtility getJSONFromDict:dict]);
    
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalConcurrentQueue, ^{
        
        [self.manager POST:strApi parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseObject) {
                    
//                    NSLog(@"getJSONFromDict %@",[SLUtility getJSONFromDict:responseObject]);
                }
                completionBlock(YES,nil,responseObject);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSMutableDictionary *response = [NSMutableDictionary dictionary];
            [response setObject:error forKey:@"Error"];
            [response setObject:error.localizedDescription forKey:KresponseMessage];
//            [response setObject:KAlert_Something_Went_Wrong forKey:KresponseMessage];
//            NSLog(@"failure %@",response);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil,response);
            });
        }];
    });
}

-(void)makeGETWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock{
    
//    NSLog(@"getJSONFromDict %@",[POSAppUtility getJSONFromDict:dict]);
    
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalConcurrentQueue, ^{
        
        [self.manager GET:strApi parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseObject) {
                    
//                    NSLog(@"getJSONFromDict %@",[POSAppUtility getJSONFromDict:responseObject]);
                }
                completionBlock(YES,nil,responseObject);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSMutableDictionary *response = [NSMutableDictionary dictionary];
            [response setObject:error forKey:@"Error"];
            [response setObject:error.localizedDescription forKey:KresponseMessage];

//            NSLog(@"failure %@",response);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil,response);
            });
        }];
    });
}

-(void)makeDeleteWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock{
    
//    NSLog(@"getJSONFromDict %@",[POSAppUtility getJSONFromDict:dict]);
    
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalConcurrentQueue, ^{
        
        [self.manager DELETE:strApi parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseObject) {
                    
//                    NSLog(@"getJSONFromDict %@",[POSAppUtility getJSONFromDict:responseObject]);
                }
                completionBlock(YES,nil,responseObject);
            });

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSMutableDictionary *response = [NSMutableDictionary dictionary];
            [response setObject:error forKey:@"Error"];
            [response setObject:error.localizedDescription forKey:KresponseMessage];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil,response);
            });
        }];
    });
}

@end
