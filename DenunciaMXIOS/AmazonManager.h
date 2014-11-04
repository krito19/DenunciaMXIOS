//
//  AmazonManager.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 13/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>
#import <AWSiOSSDKv2/S3.h>
#import "Evidencia.h"

@interface AmazonManager : NSObject

+(id)sharedAManager;

@property (nonatomic, strong) AWSS3TransferManager *transferManager;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) NSString *state;

-(void)pauseAll;
-(void)resumeAll;

-(void)addRequestWithEvidencia:(Evidencia *)evi progressBlock:(AWSNetworkingUploadProgressBlock)uploadProgress finishedBlock:(id (^)())block;

@end
