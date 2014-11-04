//
//  HomeController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnEmergencias;
@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (nonatomic, strong) NSString *idDenuncia;

@end
