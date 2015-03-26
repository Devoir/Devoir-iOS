//
//  SignInViewController.m
//  devoir-ios
//
//  Created by Brent on 3/20/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "SignInViewController.h"
#import "VariableStore.h"

@interface SignInViewController() <GPPSignInDelegate>
@property (weak, nonatomic) GPPSignIn* signIn;
@property (retain, nonatomic) IBOutlet GPPSignInButton* signInButton;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication])
    {
        // The user is signed in.
        [self performSegueWithIdentifier:@"login_with_course" sender:self];
        //[self performSegueWithIdentifier:@"login_no_course" sender:self];
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
        //TRY TO LOGIN ON SERVER
        //Set all needed user variables such as theme color
        NSLog(@"%@", [GPPSignIn sharedInstance].userEmail);
        GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
        NSLog(@"%@", person.displayName);
        NSLog(@"%@", [auth accessToken]);
        
        [self refreshInterfaceBasedOnSignIn];
    }
}

@end
