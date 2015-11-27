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
//  AboutViewController.m
//  BLE Commander
//
//  Created by Aaron Stephenson on 1/07/2015.
//  Copyright (c) 2015 Zentri. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController () <UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *zentriLinkButton;

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", majorVersion];
    [_zentriLinkButton setTitleColor:[UIColor colorWithRed:240.0f/255.0f green:95.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openURL:(id)sender
{
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"https://zentri.com/contact-us/"]])
    {
        NSString *messageTitle = @"Open URL";
        NSString *messageBody = @"Would you like to open this URL in Safari?";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:messageTitle message:messageBody preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Open Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://zentri.com/contact-us"]];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:messageTitle
                                                              message:messageBody
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Open Safari", nil];
            [message show] ;
        }
    }
}

#define mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://zentri.com/contact-us/"]];
    }
}

@end
