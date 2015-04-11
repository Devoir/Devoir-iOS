//
//  AppDelegate.m
//  devoir-ios
//
//  Created by Candice Davis on 2/7/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AppDelegate.h"
#import "VariableStore.h"
#import "DBAccess.h"
#import <GooglePlus/GooglePlus.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self checkAndCreateDatabase];

    //try to get theme color from user
    DBAccess *databse = [[DBAccess alloc] init];
    User *user = [databse getUser];
    if(user)
    {
        [VariableStore sharedInstance].themeColor = user.themeColor;
    }
    
    //try to log user in
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootViewController = nil;

    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.clientID = [VariableStore sharedInstance].googleOAtuhClientID;
    
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    BOOL look = [signIn trySilentAuthentication];
    if(look)
    {
        rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    }
    else
    {
        //!!!!!clear database!!!!!
        rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    }
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(NSString *)GetDocumentDirectory {
    self.fileMgr = [NSFileManager defaultManager];
    self.homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return self.homeDir;
}

-(void) checkAndCreateDatabase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *databasePath = [self.GetDocumentDirectory stringByAppendingPathComponent:[VariableStore sharedInstance].dbPath];
    success = [fileManager fileExistsAtPath:databasePath];
    if(success)
    {
        NSLog(@"working");
        return;
    }
    else
    {
        NSLog(@"notworking");
        NSString *databasePathFromApp =
        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[VariableStore sharedInstance].dbPath];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end