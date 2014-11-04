//
//  AppDelegate.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 26/09/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "AppDelegate.h"
#import "AWSCore.h"
#import "AWSCredentialsProvider.h"
#import "WSManager.h"
#import "JSONParser.h"
#import "AmazonManager.h"
#import "DBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Push Notifications Managment

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"ST" forKey:@"Token"];
    [defaults synchronize];

}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *str = [NSString stringWithFormat:@"%@",deviceToken];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *strToken = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strToken = [strToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"TOKEN: %@",strToken);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Token"];
    if (token == nil || ![token isEqualToString:strToken])
    {
        [defaults setObject:strToken forKey:@"Token"];
        [defaults synchronize];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           NSString *content = [JSONParser JSONStringForDevice];
                           NSDictionary *dic = [WSManager registrarDeviceConContent:content];
                           BOOL suc = [[dic objectForKey:@"success"] boolValue];
                           
                           if (suc)
                               NSLog(@"Registrado Exitósamente");
                           else
                               NSLog(@"No se pudo registrar");
                       });
    }
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"Received notification: %@", userInfo);
    
    [JSONParser parserJSONForStatus:userInfo];
    DBManager *db = [DBManager sharedDBManager];
    [db saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotificationMessageReceivedNotification" object:nil userInfo:userInfo];
}


#pragma mark - Defaults

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
                                                          credentialsWithRegionType:AWSRegionUSEast1
                                                          accountId:@""
                                                          identityPoolId:@""
                                                          unauthRoleArn:@""
                                                          authRoleArn:@""];
    
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1
                                                                          credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        NSLog(@"Received notification: %@", userInfo);
        
        [JSONParser parserJSONForStatus:userInfo];
        DBManager *db = [DBManager sharedDBManager];
        [db saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotificationMessageReceivedNotification" object:nil userInfo:userInfo];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    AmazonManager *am = [AmazonManager sharedAManager];
    [am pauseAll];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    AmazonManager *am = [AmazonManager sharedAManager];
    [am pauseAll];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    AmazonManager *am = [AmazonManager sharedAManager];
    [am resumeAll];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.syca.DenunciaMXIOS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DenunciaMXIOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DenunciaMXIOS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
