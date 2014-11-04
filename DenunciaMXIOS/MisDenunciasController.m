//
//  MisDenunciasController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 07/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "MisDenunciasController.h"
#import "Denuncia.h"
#import "DenunciaCell.h"
#import "DenunciarController.h"

@interface MisDenunciasController ()

@end

@implementation MisDenunciasController

#pragma mark - IBActions

- (IBAction)goMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma  mark - Table Manage

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.denuncias.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DenunciaCell *celda = [self.table dequeueReusableCellWithIdentifier:@"DenunciaCell"];
    
    Denuncia *den = [self.denuncias objectAtIndex:indexPath.row];
    [celda configurarCeldaConDenuncia:den];
    //[celda setBackgroundColor:[UIColor clearColor]];
    //[celda.backgroundView setBackgroundColor:[UIColor clearColor]];
    
    return celda;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DenunciarController *deunciarController = [self.storyboard instantiateViewControllerWithIdentifier:@"DenunciarController"];
    deunciarController.denuncia = [self.denuncias objectAtIndex:indexPath.row];
    deunciarController.fromDenuncias = YES;
    deunciarController.delegado = self;
    [self.navigationController pushViewController:deunciarController animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Denuncia *den = [self.denuncias objectAtIndex:indexPath.row];
        [self.dbManger borrarElemento:den];
        self.denuncias = [self.dbManger obtenerTodasLasDenuncias];
        [self.table reloadData];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Eliminar";
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.dbManger = [DBManager sharedDBManager];
    self.denuncias = [self.dbManger obtenerTodasLasDenuncias];
    [self.lblTitulo setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];
        
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    
    self.table.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.goToMenu = NO;
    
    if (self.idDenuncia != nil && ![self.idDenuncia isEqualToString:@""])
    {
        Denuncia *den = [self.dbManger obtenerDenunciaConID:self.idDenuncia];
        DenunciarController *deunciarController = [self.storyboard instantiateViewControllerWithIdentifier:@"DenunciarController"];
        deunciarController.denuncia = den;
        deunciarController.fromDenuncias = YES;
        deunciarController.delegado = self;
        [self.navigationController pushViewController:deunciarController animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.goToMenu)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    self.denuncias = [self.dbManger obtenerTodasLasDenuncias];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
