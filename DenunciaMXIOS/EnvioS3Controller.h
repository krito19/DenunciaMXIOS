//
//  EnvioS3Controller.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 13/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSiOSSDKv2/S3.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface EnvioS3Controller : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *request;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) uint64_t tam;

@end
