//
//  SignInViewController.m
//  devoir-ios
//
//  Created by Brent on 3/20/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "SignInViewController.h"
#import "VariableStore.h"
#import "DBAccess.h"
#import "ServerAccess.h"
#import "UserServerAccess.h"

@interface SignInViewController() <GPPSignInDelegate, UserServerAccessDelegate>
@property (weak, nonatomic) GPPSignIn* signIn;
@property (retain, nonatomic) IBOutlet GPPSignInButton* signInButton;
@property (retain, nonatomic) ServerAccess *serverAccess;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInButton.colorScheme = kGPPSignInButtonColorSchemeDark;
    //self.signInButton.colorScheme = kGPPSignInButtonColorSchemeLight;
    
    GPPSignInButtonStyle newStyle;
    newStyle = kGPPSignInButtonStyleStandard;
    //newStyle = kGPPSignInButtonStyleWide;
    //newStyle = kGPPSignInButtonStyleIconOnly;
    self.signInButton.style = newStyle;
    
    
    self.signIn = [GPPSignIn sharedInstance];
    self.signIn.shouldFetchGooglePlusUser = YES;
    self.signIn.shouldFetchGoogleUserEmail = YES;
    
    self.signIn.clientID = [VariableStore sharedInstance].googleOAtuhClientID;
    
    self.signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    self.signIn.delegate = self;
}

#pragma mark - GPPSignInDelegate methods

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication])
    {
        // The user is signed in.
        [self performSegueWithIdentifier:@"login_with_course" sender:self];
    }
    else
    {
        //signed out
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    if (error)
    {
        NSLog(@"Received error %@", error);
    }
    else
    {
        //INVERT THIS COMMENTING TO USE SERVER STUFF
        [self refreshInterfaceBasedOnSignIn];
        //self.serverAccess = [[ServerAccess alloc] init];
        //[self.serverAccess loginUserWithEmail:[GPPSignIn sharedInstance].userEmail Sender:self];
    }
}

#pragma mark - UserServerAccessDelegate methods

- (void)didLogin:(NSNumber*)loginValue {
    BOOL success = [loginValue boolValue];
    if(success)
    {
        [self.serverAccess addCoursesFromServer];
        [self.serverAccess addAssignmentsFromServer];
        [self refreshInterfaceBasedOnSignIn];
    }
    else
    {
        [[GPPSignIn sharedInstance] signOut];
        [self refreshInterfaceBasedOnSignIn];
    }
}

- (void)connectionDidFail:(NSError *)error {
    [[GPPSignIn sharedInstance] signOut];
    [self refreshInterfaceBasedOnSignIn];
}

@end
