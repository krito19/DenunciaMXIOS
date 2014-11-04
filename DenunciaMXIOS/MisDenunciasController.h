//
//  MisDenunciasController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 07/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Denuncia.h"
#import "DBManager.h"

@interface MisDenunciasController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;

@property (nonatomic, strong) NSArray *denuncias;
@property (nonatomic, strong) DBManager *dbManger;
@property (nonatomic, assign) BOOL goToMenu;
@property (nonatomic, strong) NSString *idDenuncia;
@end
