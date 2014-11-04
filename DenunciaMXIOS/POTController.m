//
//  POTController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "POTController.h"

@interface POTController ()

@end

@implementation POTController

#pragma mark - IBActions

- (IBAction)goMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.viewTop setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0]];
    [self.lblTitulo setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
