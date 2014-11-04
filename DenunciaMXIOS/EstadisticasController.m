//
//  EstadisticasController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "EstadisticasController.h"

@interface EstadisticasController ()

@end

@implementation EstadisticasController


#pragma mark - Table Managment

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dependencias.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    [cell.textLabel setText:[self.dependencias objectAtIndex:indexPath.row]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

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
    self.dependencias = [NSArray arrayWithObjects:@"AEROPUERTOS Y SERVICIOS AUXILIARES (ASA)",@"CAMINOS Y PUENTES FEDERALES DE INGRESOS Y SERVICIOS CONEXOS",@"PEMEX EXPLORACION Y PRODUCCION",@"COMISIóN NACIONAL DE PROTECCIóN SOCIAL EN SALUD",@"DICONSA. S.A. DE C.V",@"INSTITUTO POLITECNICO NACIONAL",@"SECRETARIA DE TURISMO",@"SERVICIO DE ADMINISTRACION TRIBUTARIA",@"SECRETARIA DEL TRABAJO Y PREVISION SOCIAL",@"POLICIA FEDERAL",@"COMISION NACIONAL DEL AGUA",@"INSTITUTO MEXICANO DEL SEGURO SOCIAL (IMSS)",@"INSTITUTO DE SEGURIDAD Y SERVICIOS SOCIALES DE LOS TRABAJADORES",@"SERVICIO POSTAL MEXICANO (SPN)",@"SECRETARIA DE DESARROLLO SOCIAL",nil];
    [self.lblTitulo setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];
    
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
