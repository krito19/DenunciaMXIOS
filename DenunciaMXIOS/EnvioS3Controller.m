//
//  EnvioS3Controller.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 13/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "EnvioS3Controller.h"

@interface EnvioS3Controller ()

@end

@implementation EnvioS3Controller

#pragma mark - Recorder Manager

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Termino de grabar");
    NSData *data = [NSData dataWithContentsOfURL:self.url];
    self.tam = data.length;
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Ocurrio un error:%@",error.localizedDescription);
}


#pragma mark - ImagePicker Manager

- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        image = [self cutImage:image];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: self.name] ];
        NSData* data = UIImageJPEGRepresentation(image, 0.9);
        self.url = [NSURL fileURLWithPath:path];
        self.tam = data.length;
        if (![data writeToFile:path atomically:YES])
            NSLog(@"No se pudo");
    }
}

-(UIImage*)cutImage:(UIImage*)image
{
    CGSize newSize = CGSizeMake(image.size.width/3.1, image.size.height/3.1);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)tomarFoto:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)tomarVideo:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)grabarAudio:(id)sender
{
    if (self.recorder.recording)
    {
        [self.btnRecord setTitle:@"Grabar" forState:UIControlStateNormal];
        [self.recorder stop];
    }
    else
    {
        
        NSArray *dirPaths;
        NSString *docsDir;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddhhmmss"];
        self.name = [NSString stringWithFormat:@"%@.caf",[formatter stringFromDate:[NSDate date]]];
        NSString *soundFilePath = [docsDir stringByAppendingPathComponent:self.name];
        self.url = [NSURL fileURLWithPath:soundFilePath];
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0],
                                        AVSampleRateKey,
                                        nil];
        
        NSError *error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        self.recorder = nil;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:recordSettings error:&error];
        [self.recorder setDelegate:self];
        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
            return;
        } else {
            [self.recorder prepareToRecord];
        }

        
        [self.btnRecord setTitle:@"Listo" forState:UIControlStateNormal];
        [self.recorder record];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddhhmmss"];
        self.name = [NSString stringWithFormat:@"%@.MOV",[formatter stringFromDate:[NSDate date]]];
        NSURL *vUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [vUrl path];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString* documentsDir = [paths objectAtIndex:0];
        NSString *savePath = [documentsDir stringByAppendingPathComponent:self.name];
        
        NSLog(@"%@",savePath);
        
        if (![fileManager moveItemAtPath:moviePath toPath:savePath error:nil])
            NSLog(@"No se pudo gurdar video");

        self.url = [NSURL fileURLWithPath:savePath];
        NSData *data = [NSData dataWithContentsOfURL:self.url];
        self.tam = data.length;
    }
    else
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self.imgView setImage:image];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddhhmmss"];
        self.name = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
        [self saveImage:image];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - S3 Upload Manager

- (IBAction)subir:(id)sender
{
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    __weak typeof(self) mismo = self;
    self.progressView.progress = 0.0;
    
    self.request = [AWSS3TransferManagerUploadRequest new];
    [self.request setBucket:@"denunciamx"];
    [self.request setKey:self.name];
    [self.request setBody:self.url];
    NSError *err;
    if ([self.url checkResourceIsReachableAndReturnError:&err] == NO)
    {
        NSLog(@"ERror:%@",err);
        return;
    }
    
    [self.request setUploadProgress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend)
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
    }];
}

- (IBAction)pausar:(id)sender
{
    [[self.request pause] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                     withBlock:^id(BFTask *task)
    {
        if (task.error != nil)
        {
            NSLog(@"Error Pausa:%@",task.error);
            [self.lblStatus setText:@"Error la pausar"];
        }
        else
            [self.lblStatus setText:@"Pausado"];
        
        return nil;
    }];
}

- (IBAction)reanudar:(id)sender
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];

    [self.lblStatus setText:@"Reanudado"];
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
     }];
}

-(void)updateProgress:(int64_t)send
{
    self.progressView.progress = (float)send / (float)self.tam;
    NSLog(@"Subiendo...   %f/%llu",self.progressView.progress,self.tam);
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
