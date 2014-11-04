//
//  EmergenciasController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 07/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "EmergenciasController.h"

@interface EmergenciasController ()

@end

@implementation EmergenciasController

#pragma mark - IBActions

- (IBAction)irAtras:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)llamarl:(id)sender
{
    UIButton *but = (UIButton *)sender;
    NSString *numero = [self.telefonos objectAtIndex:but.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",numero]]];
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.telefonos = [[NSArray alloc] initWithObjects:@"066",@"068",@"065",@"063",@"088",@"075",@"089",@"079",@"071", nil];
    [self.lblTitulo setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
