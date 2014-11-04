//
//  EvidenciaController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "EvidenciaController.h"
#import <QuartzCore/QuartzCore.h>
#import "ManejadorArchivos.h"
#import "Evidencia.h"
#import "DBManager.h"

@interface EvidenciaController ()

@end

@implementation EvidenciaController

#pragma mark - Refresh Scrolls

-(void)cleanScroll:(UIScrollView *)scroll
{
    NSArray *subViews = [scroll subviews];
    for (UIView *v in subViews)
        [v removeFromSuperview];
}

-(void)generateThumbImgWithUrl:(NSString *)urlString withImgV:(UIImageView *)imgV
{
    NSURL *url = [NSURL fileURLWithPath:urlString];
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0.0,600);
    
    
    __block UIImage *thumbImg;
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        thumbImg = [UIImage imageWithCGImage:im];
        imgV.image = thumbImg;
        UIImageView *imgPlay = [[UIImageView alloc] initWithFrame:CGRectMake(17, 24, 30, 30)];
        [imgPlay setImage:[UIImage imageNamed:@"IconoPlay.png"]];
        [imgV addSubview:imgPlay];
    };
    
    CGSize maxSize = CGSizeMake(64, 79);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
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

-(void)refreshImgScroll
{
    [self cleanScroll:self.scrollImg];
    int count = 0;
    for (Evidencia *ev in self.imageList)
    {
        int x = (count * 64) + (10*count);
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 64, 79)];
        imgV.image = [UIImage imageWithContentsOfFile:[self obtenerRutaDeElemento:ev.ruta]];
        [imgV setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.3]];
        [imgV setContentMode:UIViewContentModeScaleAspectFit];
        imgV.tag = count;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCurrentImg:)];
        [imgV addGestureRecognizer:tap];
        [imgV setUserInteractionEnabled:YES];
        [self.scrollImg addSubview:imgV];
        if (count == self.currentImg)
        {
            [imgV.layer setBorderColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0].CGColor];
            [imgV.layer setBorderWidth:1];
        }
        count++;
    }
    
    int x = (count*64)+(10*count);
    [self.scrollImg setContentSize:CGSizeMake(x, self.scrollImg.frame.size.height)];
    [self.scrollImg setPagingEnabled:YES];
}

-(void)refreshVideoScroll
{
    [self cleanScroll:self.scrollVideo];
    int count = 0;
    for (Evidencia *evidencia in self.videoList)
    {
        int x = (count * 64) + (10*count);
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 64, 79)];
        [imgV setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.3]];
        [imgV setContentMode:UIViewContentModeScaleAspectFit];
        imgV.tag = count;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCurrentVideo:)];
        [imgV addGestureRecognizer:tap];
        [imgV setUserInteractionEnabled:YES];
        [self.scrollVideo addSubview:imgV];
        [self generateThumbImgWithUrl:[self obtenerRutaDeElemento:evidencia.ruta] withImgV:imgV];
        if (count == self.currentVideo)
        {
            [imgV.layer setBorderColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0].CGColor];
            [imgV.layer setBorderWidth:.5];
        }
        count++;
    }
    int x = (count*64)+(10*count);
    [self.scrollVideo setContentSize:CGSizeMake(x, self.scrollVideo.frame.size.height)];
    [self.scrollVideo setPagingEnabled:YES];
}

-(void)refreshAudioScroll
{
    [self cleanScroll:self.scrollAudio];
    int count = 0;
    for (Evidencia *evidencia in self.audioList)
    {
        int x = (count * 64) + (10*count);
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 64, 79)];
        imgV.image = [UIImage imageNamed:@"Audio.png"];
        [imgV setBackgroundColor:[UIColor blackColor]];
        [imgV setContentMode:UIViewContentModeScaleAspectFit];
        imgV.tag = count;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCurrentAudio:)];
        [imgV addGestureRecognizer:tap];
        [imgV setUserInteractionEnabled:YES];
        [self.scrollAudio addSubview:imgV];
        if (count == self.currentAudio)
        {
            [imgV.layer setBorderColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0].CGColor];
            [imgV.layer setBorderWidth:.5];
        }
        count++;
    }
    int x = (count*64)+(10*count);
    [self.scrollAudio setContentSize:CGSizeMake(x, self.scrollAudio.frame.size.height)];
    [self.scrollAudio setPagingEnabled:YES];
}

-(void)selectCurrentAudio:(UITapGestureRecognizer *)recognizer
{
    self.currentAudio = (int)recognizer.view.tag;
    [self refreshAudioScroll];
}

-(void)selectCurrentImg:(UITapGestureRecognizer *)recognizer
{
    self.currentImg = (int)recognizer.view.tag;
    [self refreshImgScroll];
}

-(void)selectCurrentVideo:(UITapGestureRecognizer *)recognizer
{
    self.currentVideo = (int)recognizer.view.tag;
    [self refreshVideoScroll];
}

#pragma mark - Image & Vidio Manager

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.isPhoto)
    {
        [self.delegate dismissViewControllerAnimated:YES completion:nil];
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        img = [self fixImageOrientation:img];
        NSString *imgName = [NSString stringWithFormat:@"Imagen%d.jpg",(int)self.imageList.count+1];
        NSString *imgUrl = [self.urlDenuncia stringByAppendingPathComponent:imgName];
        if ([ManejadorArchivos guardarImagen:img enRuta:imgUrl])
        {
            Evidencia *evidencia = [self.dbManager evidenciaManaged];
            evidencia.idDenuncia = self.guid;
            evidencia.tipo = [NSNumber numberWithInt:1];
            evidencia.nombre = imgName;
            evidencia.ruta = [NSString stringWithFormat:@"/%@/%@",self.guid,imgName];
            evidencia.enviados = [NSNumber numberWithLongLong:0];
            evidencia.totales = [NSNumber numberWithLongLong:0];
            evidencia.eviado = [NSNumber numberWithBool:NO];
          
            if ([self.dbManager saveContext])
            {
                self.imageList = [self.dbManager obtenerEvidenciaDeDenuncia:self.guid conTipo:1];
                [self refreshImgScroll];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar la evidencia" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar la evidencia" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        [self.delegate dismissViewControllerAnimated:YES completion:nil];
        NSString *name = [NSString stringWithFormat:@"Video%d.MOV",(int)self.videoList.count+1];
        NSURL *vUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [vUrl path];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString *savePath = [self.urlDenuncia stringByAppendingPathComponent:name];
        
        NSLog(@"%@",savePath);
        
        if (![fileManager moveItemAtPath:moviePath toPath:savePath error:nil])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar la evidencia" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alert show];

        }
        else
        {
            Evidencia *evidencia = [self.dbManager evidenciaManaged];
            evidencia.idDenuncia = self.guid;
            evidencia.tipo = [NSNumber numberWithInt:2];
            evidencia.nombre = name;
            evidencia.ruta = [NSString stringWithFormat:@"/%@/%@",self.guid,name];
            evidencia.enviados = [NSNumber numberWithLongLong:0];
            evidencia.totales = [NSNumber numberWithLongLong:0];
            evidencia.eviado = [NSNumber numberWithBool:NO];
            
            if ([self.dbManager saveContext])
            {
                self.videoList = [self.dbManager obtenerEvidenciaDeDenuncia:self.guid conTipo:2];
                [self refreshVideoScroll];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar la evidencia" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alert show];
            }
            
        }
    }
}

- (UIImage *)fixImageOrientation:(UIImage *)imagenAarreglar {
    
    // No-op if the orientation is already correct
    if (imagenAarreglar.imageOrientation == UIImageOrientationUp) return imagenAarreglar;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (imagenAarreglar.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imagenAarreglar.size.width, imagenAarreglar.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imagenAarreglar.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imagenAarreglar.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (imagenAarreglar.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imagenAarreglar.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imagenAarreglar.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imagenAarreglar.size.width, imagenAarreglar.size.height,
                                             CGImageGetBitsPerComponent(imagenAarreglar.CGImage), 0,
                                             CGImageGetColorSpace(imagenAarreglar.CGImage),
                                             CGImageGetBitmapInfo(imagenAarreglar.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imagenAarreglar.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imagenAarreglar.size.height,imagenAarreglar.size.width), imagenAarreglar.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imagenAarreglar.size.width,imagenAarreglar.size.height), imagenAarreglar.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark - Recorder Manager

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Termino de grabar, RelaPath:%@  RelaString:%@",self.recorder.url.absoluteString,self.recorder.url.relativeString);
    NSString *nombre = [NSString stringWithFormat:@"Audio%d.caf",(int)self.audioList.count+1];
    NSString *pathAudio = [self.guid stringByAppendingPathComponent:nombre];
    Evidencia *evidencia = [self.dbManager evidenciaManaged];
    evidencia.idDenuncia = self.guid;
    evidencia.tipo = [NSNumber numberWithInt:3];
    evidencia.nombre = nombre;
    evidencia.ruta = pathAudio;
    evidencia.enviados = [NSNumber numberWithLongLong:0];
    evidencia.totales = [NSNumber numberWithLongLong:0];
    evidencia.eviado = [NSNumber numberWithBool:NO];
    
    if ([self.dbManager saveContext])
    {
        self.audioList = [self.dbManager obtenerEvidenciaDeDenuncia:self.guid conTipo:3];
        [self refreshAudioScroll];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Error al guardar la evidencia" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Ocurrio un error:%@",error.localizedDescription);
}

-(void)prepararParaGrabar
{
    NSString *nombre = [NSString stringWithFormat:@"Audio%d.caf",(int)self.audioList.count+1];
    NSString *soundFilePath = [self.urlDenuncia stringByAppendingPathComponent:nombre];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
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
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    self.recorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    [self.recorder setDelegate:self];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [self.recorder prepareToRecord];
    }
}

#pragma mark - IBActions

- (IBAction)record:(id)sender
{
    if (self.recorder.recording)
    {
        [self.btnRecord setImage:[UIImage imageNamed:@"BotonAgregar.png"] forState:UIControlStateNormal];
        [self.btnAddAudio2 setImage:[UIImage imageNamed:@"IconoMicrofono.png"] forState:UIControlStateNormal];
        [self.recorder stop];
    }
    else
    {
        [self prepararParaGrabar];
        [self.btnRecord setImage:[UIImage imageNamed:@"BotonPararAudio.png"] forState:UIControlStateNormal];
        [self.btnAddAudio2 setImage:[UIImage imageNamed:@"IconoStop.png"] forState:UIControlStateNormal];
        [self.recorder record];
    }
}

- (IBAction)recordVideo:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.isPhoto = NO;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [picker setDelegate:self];
        NSArray *mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        picker.mediaTypes = mediaTypes;
        [self.delegate presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Tu dispositivo no tiene disponible cámara" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)takePhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.isPhoto = YES;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //NSArray *mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        //picker.mediaTypes = mediaTypes;
        [self.delegate presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Tu dispositivo no tiene disponible cámara" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)lookForImage:(id)sender
{
    self.isPhoto = YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray *mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    picker.mediaTypes = mediaTypes;
    [self.delegate presentViewController:picker animated:YES completion:nil];
}

- (IBAction)lookForVideo:(id)sender
{
    self.isPhoto = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray *mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    picker.mediaTypes = mediaTypes;
    [self.delegate presentViewController:picker animated:YES completion:nil];
}

- (IBAction)deleteImg:(id)sender
{
    if (self.currentVideo < 0 || self.currentImg > self.imageList.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Se debe seleccionar la imagen a eliminar" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self alertarDelete];
    
    //[self.imageList removeObjectAtIndex:self.currentImg];
    //[self refreshImgScroll];
}

- (IBAction)deleteAudio:(id)sender
{
    if (self.currentAudio < 0 || self.currentAudio > self.audioList.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Se debe seleccionar el audio a eliminar" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self alertarDelete];
    
    //[self.audioList removeObjectAtIndex:self.currentAudio];
    //[self refreshAudioScroll];
}

-(IBAction)deleteVideo:(id)sender
{
    if (self.currentVideo < 0 || self.currentVideo > self.videoList.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Se debe seleccionar el video a eliminar" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self alertarDelete];
    
    //[self.videoList removeObjectAtIndex:self.currentVideo];
    //[self refreshVideoScroll];
}

-(void)alertarDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Por el momento la funcionalidad borrar esta deshabilitada" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Personalizar Campos

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)personalizarFields:(UITextField *)fld
{
    [fld.layer setBorderColor:[UIColor whiteColor].CGColor];
    [fld.layer setBorderWidth:.5];
    [fld setBorderStyle:UITextBorderStyleNone];
    [fld setTextColor:[UIColor whiteColor]];
    [fld setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"hola" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}]];
    [fld setDelegate:self];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, fld.frame.size.height)];
    fld.leftView = paddingView;
    fld.leftViewMode = UITextFieldViewModeAlways;
    
}

-(void)setEvidenciaConGuid:(NSString *)guid editable:(BOOL)editable
{
    self.guid = guid;
    self.imageList = [self.dbManager obtenerEvidenciaDeDenuncia:self.guid conTipo:1];
    self.videoList = [self.dbManager obtenerEvidenciaDeDenuncia:self.guid conTipo:2];
    self.audioList = [self.dbManager obtenerEvidenciaDeDenuncia:self.guid conTipo:3];
    
    [self refreshAudioScroll];
    [self refreshImgScroll];
    [self refreshVideoScroll];
    
    if (!editable)
    {
        [self.btnAddImg setEnabled:NO];
        [self.btnAddAudio setEnabled:NO];
        [self.btnAddVideo setEnabled:NO];
        [self.btnCamera setEnabled:NO];
        [self.btnAddAudio2 setEnabled:NO];
        [self.btnVideo setEnabled:NO];
        [self.btnBorrarImg setEnabled:NO];
        [self.btnBorrarAudio setEnabled:NO];
        [self.btnBorrarVideo setEnabled:NO];
    }
}

#pragma mark - Default

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.viewGeneral setBackgroundColor:[UIColor clearColor]];
    [self.lblTitulo setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];
    
    self.audioList = [[NSArray alloc] init];
    self.videoList = [[NSArray alloc] init];
    self.imageList = [[NSArray alloc] init];
    
    self.currentImg = -1;
    self.currentAudio = -1;
    self.currentVideo = -1;
    
    self.dbManager = [DBManager sharedDBManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
