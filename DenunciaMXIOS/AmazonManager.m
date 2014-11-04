//
//  AmazonManager.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 13/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "AmazonManager.h"

@implementation AmazonManager

+(id)sharedAManager
{
    static AmazonManager *amazonManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void)
                  {
                      amazonManager = [[self alloc] init];
                  });
    return amazonManager;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        self.transferManager = [AWSS3TransferManager defaultS3TransferManager];
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        [self.reachability startNotifier];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

-(void)pauseAll
{
    [self.transferManager pauseAll];
    self.state = @"Paused";
    NSLog(@"Se pararon las transferencias");
}

-(void)resumeAll
{
    [self.transferManager resumeAll:^(AWSRequest *request)
     {
         [self didFinishUploads];
    }];
    self.state = @"Uploading";
    NSLog(@"Se continuaron todas las transferencias");
}

-(void)didFinishUploads
{
    self.state = @"Finished";
    NSLog(@"Se terminaron las subidas");
}


- (void)reachabilityDidChange:(NSNotification *)notification
{
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable])
    {
        NSLog(@"Reachable");
        if ([reachability isReachableViaWiFi])
        {
            [self resumeAll];
        }
        else
        {
            [self resumeAll];
        }
    }
    else
    {
        NSLog(@"Unreachable");
        [self.transferManager pauseAll];
    }
}


-(void)addRequestWithEvidencia:(Evidencia *)evi progressBlock:(AWSNetworkingUploadProgressBlock)uploadProgress finishedBlock:(id (^)())block
{
    NSDateFormatter *formato = [[NSDateFormatter alloc] init];
    [formato setDateFormat:@"yyyyMMdd"];
    NSString *tipo;
    if (evi.tipo.intValue == 1)
        tipo = @"FOTO";
    if (evi.tipo.intValue == 2)
        tipo = @"VIDEO";
    if (evi.tipo.intValue == 3)
        tipo = @"AUDIO";
    NSString *key = [NSString stringWithFormat:@"%@/%@/%@/%@",[formato stringFromDate:[NSDate date]],evi.idDenuncia,tipo,evi.nombre];
    NSString *ruta = [self obtenerRutaDeElemento:evi.ruta];
    NSURL *url = [NSURL fileURLWithPath:ruta];
    
    AWSS3TransferManagerUploadRequest *request = [AWSS3TransferManagerUploadRequest new];
    [request setBucket:@"denunciamx"];
    [request setKey:key];
    [request setBody:url];
    NSError *err;
    if ([url checkResourceIsReachableAndReturnError:&err] == NO)
    {
        NSLog(@"ERror:%@",err);
        return;
    }
    
    [request setUploadProgress:uploadProgress];
    [[self.transferManager upload:request] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:block];
    
    /*[request setUploadProgress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend)
     {
         dispatch_sync(dispatch_get_main_queue(), ^(void)
                       {
                           [mismo updateProgress:totalBytesSent];
                       });
     }];
    
    [[transferManager upload:self.request] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task)
     {
         if (task.error != nil)
             NSLog(@"Error: %@",task.error.localizedDescription);
         else
         {
             self.request = nil;
             [self.lblStatus setText:@"Subido"];
         }
         
         return nil;
     }];*/
}

-(NSString *)obtenerRutaDeElemento:(NSString *)ele
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSString *fullPath = [docsDir stringByAppendingFormat:@"/%@",ele];
    return fullPath;
}


@end
