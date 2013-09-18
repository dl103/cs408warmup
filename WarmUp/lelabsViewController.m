//
//  lelabsViewController.m
//  WarmUp
//
//  Created by davile2 on 9/16/13.
//  Copyright (c) 2013 Le Labs. All rights reserved.
//

#import "lelabsViewController.h"
@interface lelabsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testUsername;
@property (weak, nonatomic) IBOutlet UITextField *testPassword;
@end

@implementation lelabsViewController
@synthesize testUsername;
@synthesize testPassword;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(UIBarButtonItem *)sender {
    if([testUsername.text isEqualToString:@"admin"] && [testPassword.text isEqualToString:@"admin"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                        message:@"Login successful!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)backgroundClick:(id)sender {
}
@end
