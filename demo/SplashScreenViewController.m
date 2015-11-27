/*
 *
 *  # Zentri BLE Commander
 *  Android application for updating the firmware of Zentri BLE devices over BLE (Bluetooth Low Energy).
 *
 *  # License
 *
 *  Copyright (C) 2015, Zentri, Inc. All Rights Reserved.
 *
 *  The Zentri BLE iOS Framework and Zentri BLE example applications are provided free of charge
 *  by Zentri. The combined source code, and all derivatives, are licensed by Zentri SOLELY for use
 *  with devices manufactured by Zentri, or devices approved by Zentri.
 *
 *  Use of this software on any other devices or hardware platforms is strictly prohibited.
 *  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AS IS AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 *  BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

//
//  SplashScreenViewController.m
//  BLE Commander
//
//  Created by Aaron Stephenson on 7/07/2015.
//  Copyright (c) 2015 Zentri. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController () <UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLinkOneLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLinkTwoLabel;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SplashScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    self.mainLabel.numberOfLines = 0;
    self.mainLabel.text = [NSString stringWithFormat:@"%@\nVersion %@", appDisplayName, majorVersion];
    self.urlLinkOneLabel.text = @"https://docs.zentri.com/";
    self.urlLinkOneLabel.textColor = [UIColor colorWithRed:240.0f/255.0f green:95.0f/255.0f blue:34.0f/255.0f alpha:1];
    self.urlLinkTwoLabel.text = @"https://zentri.com/contact-us/";
    self.urlLinkTwoLabel.textColor = [UIColor colorWithRed:240.0f/255.0f green:95.0f/255.0f blue:34.0f/255.0f alpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Delay execution of my block for 10 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showMainView) userInfo:nil repeats:NO];
    });
}

- (void)showMainView
{
    [self performSegueWithIdentifier:@"showMainView" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectedLinkOne:(id)sender
{
    [self.timer invalidate];
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"https://docs.zentri.com/"]])
    {
        NSString *messageTitle = @"Open URL";
        NSString *messageBody = @"Would you like to open this URL in Safari?";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [self openAlertController:messageTitle withBody:messageBody withURL:[NSURL URLWithString:@"https://docs.zentri.com/"]];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:messageTitle
                                                              message:messageBody
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Open Safari", nil];
            message.tag = 1;
            [message show] ;
        }
    }
}

- (IBAction)selectedLinkTwo:(id)sender
{
    [self.timer invalidate];
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"https://zentri.com/contact-us/"]])
    {
        NSString *messageTitle = @"Open URL";
        NSString *messageBody = @"Would you like to open this URL in Safari?";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [self openAlertController:messageTitle withBody:messageBody withURL:[NSURL URLWithString:@"https://zentri.com/contact-us/"]];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:messageTitle
                                                              message:messageBody
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Open Safari", nil];
            message.tag = 2;
            [message show] ;
        }
    }
}

- (void)openAlertController:(NSString *)title withBody:(NSString *)body withURL:(NSURL *)url
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:body preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Open Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[UIApplication sharedApplication] openURL:url];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showMainView) userInfo:nil repeats:NO];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#define mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://docs.zentri.com/"]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://zentri.com/contact-us/"]];
        }
    }
    else
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showMainView) userInfo:nil repeats:NO];
    }
}

@end
