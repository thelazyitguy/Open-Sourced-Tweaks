//
//  ViewController.m
//  ios-safariview-example
//
//  Created by iskandar.setiadi on 9/1/16.
//  Copyright © 2016 Freedomofkeima Zone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// Your server endpoint here
// This URL should return a custom URL scheme, e.g., freedomofkeima://?ThisIsResponseSample
NSString *url_endpoint = @"https://www.apple.com/uk/";
BOOL is_startup = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set notification handler for SFSafariViewController callback
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(safariCallback:) name:@"SafariCallback" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if (is_startup) {
        BOOL isSafariViewSupported = [self showSafariPage];
        NSLog(@"Support? %d", isSafariViewSupported);
        if (!isSafariViewSupported) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"iOS version is less than 9" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        is_startup = NO;
    }
}

- (BOOL)showSafariPage {
    if ([SFSafariViewController class]) {
        NSURL *url = [NSURL URLWithString:url_endpoint];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:YES completion:nil];
        return YES;
    }
    return NO;
}

- (void)safariCallback:(NSNotification *)notification {
    // Dismiss View
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // Extract information from notification
    NSDictionary *dict = [notification userInfo];
    NSString *value = [dict objectForKey:@"key"];
    NSLog(@"Value is %@", value);
    
    // Show result as alert dialog
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Key content" message:value preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - SFSafariViewController delegate methods
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    // Load finished
    NSLog(@"Load finished");
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    // Done button pressed
    NSLog(@"Done button pressed");
}

@end
