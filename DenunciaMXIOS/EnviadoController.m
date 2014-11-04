//
//  EnviadoController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "EnviadoController.h"
#import "WSManager.h"
#import "Denuncia.h"
#import "JSONParser.h"

@interface EnviadoController ()

@end

@implementation EnviadoController


#pragma mark - Manejo de Envio

-(void)enviarDenuncia:(Denuncia *)denuncia withHandle:(void(^)(void))someBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self.loader startAnimating];
        });
        
        
        NSString *content = [JSONParser JSONStringFromDenuncia:denuncia];
        NSDictionary *dic = [WSManager subirDenunciaConContent:content];
        BOOL suc = [[dic objectForKey:@"success"] boolValue];
        
        if (suc)
        {
            someBlock();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self.loader startAnimating];
            [UIView animateWithDuration:.7
                             animations:^(void)
            {
                [self.viewEnviando setAlpha:0.0];
                [self.viewGeneral setAlpha:1.0];
            }
                             completion:nil];
            
            if (suc)
            {
                [self.lblFolio setText:denuncia.idDenuncia];
                [self.lblFolio setAdjustsFontSizeToFitWidth:YES];
            }
            else
            {
                [self.lblFolio setText:denuncia.idDenuncia];
                [self.lblMessage setText:@"Ha Ocurrido un error por favor intente más tarde"];
                [self.lblFolio setAdjustsFontSizeToFitWidth:YES];
            }
        });
    });
}

-(void)setEnviado:(NSString *)folio
{
    [self.lblFolio setText:folio];
    [self.viewEnviando setAlpha:0.0];
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.viewGeneral setBackgroundColor:[UIColor clearColor]];
    [self.viewGeneral setAlpha:0.0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
