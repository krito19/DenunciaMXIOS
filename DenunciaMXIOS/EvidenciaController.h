//
//  EvidenciaController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@class DBManager;

@interface EvidenciaController : UIViewController <UITextFieldDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewGeneral;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollAudio;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnBorrarImg;
@property (weak, nonatomic) IBOutlet UIButton *btnBorrarAudio;
@property (weak, nonatomic) IBOutlet UIButton *btnBorrarVideo;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSArray *audioList;
@property (nonatomic, strong) NSArray *videoList;
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, assign) int currentImg;
@property (nonatomic, assign) int currentVideo;
@property (nonatomic, assign) int currentAudio;
@property (nonatomic, strong) UIViewController *delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImg;
@property (weak, nonatomic) IBOutlet UIButton *btnAddAudio;
@property (weak, nonatomic) IBOutlet UIButton *btnAddVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnAddAudio2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;

@property (nonatomic, strong) NSString *urlDenuncia;
@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) DBManager *dbManager;

-(void)setEvidenciaConGuid:(NSString *)guid editable:(BOOL)editable;

@end
