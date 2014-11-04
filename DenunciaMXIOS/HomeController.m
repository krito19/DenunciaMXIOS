//
//  HomeController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "HomeController.h"
#import "MisDenunciasController.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.viewTop setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0]];
    [self.btnEmergencias setBackgroundColor:[UIColor colorWithRed:152/255.0 green:48/255.0 blue:40/255.0 alpha:0.9]];
    self.idDenuncia = @"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AVISO IMPORTANTE" message:@"Este demo esta optimizado para la pantalla de 4 pulgadas (iphone 5, 5c, 5s)" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [alert show];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(remoteNotificationReceived:) name:@"PushNotificationMessageReceivedNotification"
                                               object:nil];
}

- (void)remoteNotificationReceived:(NSNotification *)notification
{
    self.idDenuncia = [[notification.userInfo valueForKey:@"denuncia"] valueForKey:@"id"];
    [self performSegueWithIdentifier:@"irDenuncias" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"irDenuncias"])
    {
        UINavigationController *nav = segue.destinationViewController;
        MisDenunciasController *denuncias =  [nav.viewControllers objectAtIndex:0];
        denuncias.idDenuncia = self.idDenuncia;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

@end
