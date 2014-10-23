//
//  MKSimpleLoginC.m
//  IMModel
//
//  Created by jimneylee on 14-5-19.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "IMSimpleLoginC.h"
#import "IMManager.h"

@interface IMSimpleLoginC ()

@end

@implementation IMSimpleLoginC

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init/dealloc methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [[IMManager sharedManager].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录注册";
        [[IMManager sharedManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userIDField.text = [[NSUserDefaults standardUserDefaults] stringForKey:XMPP_USER_ID];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:XMPP_PASSWORD];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)loginAction:(id)sender
{
    [self setField:self.userIDField forKey:XMPP_USER_ID];
    [self setField:self.passwordField forKey:XMPP_PASSWORD];
    
    [[IMManager sharedManager] connectThenLogin];
}

- (IBAction)registerAction:(id)sender
{
    [self setField:self.userIDField forKey:XMPP_USER_ID];
    [self setField:self.passwordField forKey:XMPP_PASSWORD];
    
    [[IMManager sharedManager] connectThenRegister];
}

- (void)tapAction
{
    [self.userIDField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPStreamDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

@end