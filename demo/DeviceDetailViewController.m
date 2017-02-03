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
//  DeviceDetailViewController.m
//  BLE Commander
//
//  Created by Aaron Stephenson on 1/07/2015.
//  Copyright (c) 2015 Zentri. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "StreamLineEndingViewController.h"
#import "TimedOutViewController.h"
#import "UIViewController+ENPopUp.h"
#import "zentri_ble_command/zentri_ble_command.h"

#define kStreamMode 0
#define kCommandMode 1

@interface DeviceDetailViewController () <UITextFieldDelegate, StreamLineEndingViewControllerDelegate, BLECommanderDelegate>
@property (nonatomic, weak) IBOutlet UITextField *messageTextfield;
@property (nonatomic, weak) IBOutlet UITextView *logTextView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segementControl;
@property (nonatomic, assign) BOOL lastWrittenConsoleTextWasResponseReceived;
@property (nonatomic, strong) NSString *returnLineString;
@property (nonatomic, assign) NSInteger selectedEndLineIndex;
@end

@implementation DeviceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewAppearance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"lineEndKey"])
    {
        self.selectedEndLineIndex = [[defaults objectForKey:@"lineEndKey"]integerValue];
    }
    else
    {
        self.selectedEndLineIndex = 0;
    }
}

- (void)setupViewAppearance
{
    self.messageTextfield.placeholder = @"Enter a message...";
    [self consoleAppend:@"Mode changed to STREAM MODE\n" isIncomingFromDevice:false];

    [self setupButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.segementControl.tintColor = [UIColor colorWithRed:240.0f/255.0f green:95.0f/255.0f blue:34.0f/255.0f alpha:1];
    
    //
    NSString *stringText = @"Disconnect";
    NSMutableAttributedString *titleAttributed = [[NSMutableAttributedString alloc] initWithString:stringText];
    [titleAttributed addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]
                            range:NSMakeRange(0, [stringText length])];
    [titleAttributed addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithRed:255 green:0 blue:0 alpha:1]
                            range:NSMakeRange(0, [stringText length])];
    
    CGRect frame = CGRectMake(0, 0, 80, 24);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setAttributedTitle:titleAttributed forState:UIControlStateNormal];
    button.alpha = 0.5;
    button.tintColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    [button addTarget:self action:@selector(disconnectFromDevice) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.4].CGColor;
    UIBarButtonItem* disconnectButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    disconnectButton.tintColor = [UIColor lightGrayColor];

    self.navigationItem.leftBarButtonItem = disconnectButton;

    UIColor *color = [UIColor colorWithWhite:0.516 alpha:1.000];
    self.messageTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.messageTextfield.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)setupButtons
{
    if (self.segementControl.selectedSegmentIndex == kStreamMode)
    {
        UIImage *iconImage = [UIImage imageNamed:@"icon"];
        UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aboutButton.bounds = CGRectMake(0, 0, 34, 34);
        [aboutButton addTarget:self action:@selector(showAboutView:) forControlEvents:UIControlEventTouchUpInside];
        [aboutButton setContentMode:UIViewContentModeScaleAspectFit];
        [aboutButton setImage:iconImage forState:UIControlStateNormal];
        UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
        
        UIImage *iconSettingsImage = [[UIImage imageNamed:@"icon_settings"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsButton.tintColor = [UIColor blackColor];
        settingsButton.bounds = CGRectMake(0, 0, 30, 30);
        [settingsButton addTarget:self action:@selector(showEndLineView:) forControlEvents:UIControlEventTouchUpInside];
        [settingsButton setContentMode:UIViewContentModeScaleAspectFit];
        [settingsButton setImage:iconSettingsImage forState:UIControlStateNormal];
        UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
        
        self.navigationItem.rightBarButtonItems = @[faceBtn, settingsBarButton];
    }
    else
    {
        UIImage *iconImage = [UIImage imageNamed:@"icon"];
        UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aboutButton.bounds = CGRectMake(0, 0, 34, 34);
        [aboutButton addTarget:self action:@selector(showAboutView:) forControlEvents:UIControlEventTouchUpInside];
        [aboutButton setContentMode:UIViewContentModeScaleAspectFit];
        [aboutButton setImage:iconImage forState:UIControlStateNormal];
        UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
        
        self.navigationItem.rightBarButtonItems = @[faceBtn];
    }
}

- (void)disconnectFromDevice
{
    //Disconnect from current device
    [self.mBleCommanderiOS disconnect];
    
    [self.navigationController popViewControllerAnimated:true];
}

//Adjust view size
- (void)keyboardFrameDidChange:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    
    CGRect beginFrameRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect endFrameRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (beginFrameRect.origin.y > endFrameRect.origin.y)
    {
        float keyboardSize = beginFrameRect.origin.y - endFrameRect.origin.y;
        [UIView animateWithDuration:0.35 delay:0.1 options:0 animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - keyboardSize)];
        } completion:^(BOOL finished) {
            if(self.logTextView.text.length > 0 )
            {
                if (self.logTextView.contentSize.height  > self.logTextView.bounds.size.height)
                {
                    CGPoint bottomOffset = CGPointMake(0, self.logTextView.contentSize.height - self.logTextView.bounds.size.height);
                    [self.logTextView setContentOffset:bottomOffset animated:YES];
                }
            }
        }];
    }
    else
    {
        float keyboardSize = endFrameRect.origin.y - beginFrameRect.origin.y;
        [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + keyboardSize)];
        } completion:^(BOOL finished) {
            if(self.logTextView.text.length > 0 )
            {
                if (self.logTextView.contentSize.height  > self.logTextView.bounds.size.height)
                {
                    CGPoint bottomOffset = CGPointMake(0, self.logTextView.contentSize.height - self.logTextView.bounds.size.height);
                    [self.logTextView setContentOffset:bottomOffset animated:YES];
                }
            }
        }];
    }
}

- (void)showAboutView:(id)sender
{
    [self.messageTextfield resignFirstResponder];
    [self.logTextView resignFirstResponder];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AboutView"];
    vc.view.frame = CGRectMake(0, 0, 270.0f, 290.0f);
    [self presentPopUpViewController:vc];
}

- (void)showEndLineView:(id)sender
{
    [self.messageTextfield resignFirstResponder];
    [self.logTextView resignFirstResponder];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    StreamLineEndingViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"StreamLineEndingViewController"];
    vc.view.frame = CGRectMake(0, 0, 270.0f, 290.0f);
    vc.delegate = self;
    vc.selectedIndex = self.selectedEndLineIndex;
    [self presentPopUpViewController:vc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.deviceName)
    {
        self.title = self.deviceName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getEndLineString:(NSInteger)index
{
    if (index == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"lineEndKey"])
        {
            index = [[defaults objectForKey:@"lineEndKey"]integerValue];
        }
        else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSNumber numberWithInt:self.selectedEndLineIndex] forKey:@"lineEndKey"];
            [defaults synchronize];
        }
    }
    
    NSString *endLineString = @"";
    switch (index)
    {
        case 1: //CR
            endLineString = @"\r";
            break;
        case 2: //LF
            endLineString = @"\n";
            break;
        case 3: //CRLF
            endLineString = @"\r\n";
            break;
        case 4: //LFCR
            endLineString = @"\n\r";
            break;
        default:
            break;
    }
    
    return endLineString;
}

- (void)setMBleCommanderiOS:(BLECommanderiOS *)mBleCommanderiOS
{
    _mBleCommanderiOS = mBleCommanderiOS;
    self.mBleCommanderiOS.delegate = self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.messageTextfield resignFirstResponder] ;
}

- (void)writeString:(NSString *)string
{
    NSString *stringToWrite;
    
    if (self.segementControl.selectedSegmentIndex == kCommandMode)
    {
        stringToWrite = [NSString stringWithFormat:@"%@\n\r", string];
    }
    else
    {
        NSString *endLineString = [self getEndLineString:self.selectedEndLineIndex];
        
        stringToWrite = [NSString stringWithFormat:@"%@%@", string, endLineString];
        [self appendOutgoingMessage:stringToWrite];
        self.messageTextfield.text = @"";
    }
    
//    self.messageTextfield.enabled = FALSE;
    [self.mBleCommanderiOS writeString:stringToWrite];
}

- (IBAction)busModeButtonTouched:(UISegmentedControl *)sender
{
    UIColor *color = [UIColor colorWithWhite:0.516 alpha:1.000];
    self.messageTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.messageTextfield.placeholder attributes:@{NSForegroundColorAttributeName: color}];

    self.messageTextfield.text = @"";
    self.logTextView.text = @"";
    switch (sender.selectedSegmentIndex)
    {
        case kStreamMode:
        {
            self.messageTextfield.placeholder = @"Enter a message...";
            if (![self.mBleCommanderiOS writeBusMode:STREAM_MODE])
            {
                NSLog(@"Failed to change mode to stream");
                [self.segementControl setSelectedSegmentIndex:kStreamMode];
            }
            UIColor *color = [UIColor colorWithWhite:0.516 alpha:1.000];
            self.messageTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.messageTextfield.placeholder attributes:@{NSForegroundColorAttributeName: color}];
            [self consoleAppend:@"Mode changed to STREAM MODE\n" isIncomingFromDevice:false];
            break;
        }
        case kCommandMode:
        {
            self.messageTextfield.placeholder = @"Enter a command...";
            if (![self.mBleCommanderiOS writeBusMode:REMOTE_COMMAND_MODE])
            {
                NSLog(@"Failed to change mode to remote");
                [self.segementControl setSelectedSegmentIndex:kCommandMode];
            }
            UIColor *color = [UIColor whiteColor];
            self.messageTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.messageTextfield.placeholder attributes:@{NSForegroundColorAttributeName: color}];
            [self consoleAppend:@"Mode changed to COMMAND MODE\n" isIncomingFromDevice:false];
            break ;
        }
        default:
            break;
    }
    
    if (self.messageTextfield.isFirstResponder)
    {
        self.messageTextfield.placeholder = @"";
    }
    
    [self setupButtons];
}

- (void)consoleAppend:(NSString *)string isIncomingFromDevice:(BOOL)isIncomingFromDevice
{
    [self.logTextView insertText:string] ;
    [self.logTextView scrollRangeToVisible:NSMakeRange([self.logTextView.text length], 0)] ;
}

- (BOOL)consoleWindowTextEndsInNewLine
{
    return [self.logTextView.text hasSuffix:@"\n"] || [self.logTextView.text hasSuffix:@"\r"];
}

- (BOOL)stringIsNewline:(NSString *)responseString
{
    return [responseString isEqualToString:@"\n"] || [responseString isEqualToString:@"\r"];
}

- (NSMutableAttributedString *)getResponseAttributedString:(NSString *)responseString
{
    
    NSString *prefix = @"> ";
    
    if (self.lastWrittenConsoleTextWasResponseReceived)
    {
        if([self consoleWindowTextEndsInNewLine])
        {
            responseString = [NSString stringWithFormat:@"%@  %@", prefix, responseString];
        }
        else if([self stringIsNewline:responseString])
        {
            responseString = [NSString stringWithFormat:@"\n%@  ", prefix];
        }
    }
    else
    {
        responseString = [NSString stringWithFormat:@"\n%@  %@", prefix, responseString];
    }
    
    NSMutableAttributedString *responseStringAttributed = [[NSMutableAttributedString alloc] initWithString:responseString];
    [responseStringAttributed addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:14]
                                     range:NSMakeRange(0, [responseString length])];
    [responseStringAttributed addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor greenColor]
                                     range:NSMakeRange(0, [responseString length])];
    return responseStringAttributed;
}

- (void)appendIncomingResponse:(NSString *)responseString
{
    NSMutableAttributedString *responseStringAttributed = [self getResponseAttributedString:responseString];
    NSAttributedString *currentAttributedString = self.logTextView.attributedText;
    NSMutableAttributedString *newAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:currentAttributedString];
    [newAttributedString appendAttributedString:responseStringAttributed];
    
    [self.logTextView setAttributedText:newAttributedString];
    self.lastWrittenConsoleTextWasResponseReceived = YES;
}

- (void)appendOutgoingMessage:(NSString *)outgoingMessage
{
    if(outgoingMessage)
    {
        NSMutableAttributedString *responseStringAttributed = [self getOutgoingAttributedString:outgoingMessage];
        NSAttributedString *currentAttributedString = self.logTextView.attributedText;
        NSMutableAttributedString *newAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:currentAttributedString];
        [newAttributedString appendAttributedString:responseStringAttributed];
        
        [self.logTextView setAttributedText:newAttributedString];
        self.lastWrittenConsoleTextWasResponseReceived = NO;
    }
}

- (NSMutableAttributedString *)getOutgoingAttributedString:(NSString *)outgoingMessage
{
    
    NSString *prefix = @"< ";
    outgoingMessage = [NSString stringWithFormat:@"\n%@  %@", prefix, outgoingMessage];
    
    NSMutableAttributedString *responseStringAttributed = [[NSMutableAttributedString alloc] initWithString:outgoingMessage];
    [responseStringAttributed addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:14]
                                     range:NSMakeRange(0, [outgoingMessage length])];
    [responseStringAttributed addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor whiteColor]
                                     range:NSMakeRange(0, [outgoingMessage length])];
    return responseStringAttributed;
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.messageTextfield)
    {
        [self writeString:textField.text];
    }
    
    if (self.mBleCommanderiOS.busMode == REMOTE_COMMAND_MODE)
    {
        //Command mode
        NSString *prefix = @"\n> ";
        [self consoleAppend:prefix isIncomingFromDevice:false];
    }
    
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (self.segementControl.selectedSegmentIndex)
    {
        case kStreamMode:
        {
            self.messageTextfield.placeholder = @"Enter a message...";
            UIColor *color = [UIColor colorWithWhite:0.516 alpha:1.000];
            self.messageTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.messageTextfield.placeholder attributes:@{NSForegroundColorAttributeName: color}];
            break;
        }
        case kCommandMode:
        {
            self.messageTextfield.placeholder = @"Enter a command...";
            UIColor *color = [UIColor colorWithWhite:0.516 alpha:1.000];
            self.messageTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.messageTextfield.placeholder attributes:@{NSForegroundColorAttributeName: color}];
            break ;
        }
        default:
            break;
    }
}

#pragma mark - StreamLineEndingViewControllerDelegate

- (void)didSelectALineEnding:(StreamLineEndingViewController *)controller
{
    self.selectedEndLineIndex = controller.selectedIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:self.selectedEndLineIndex] forKey:@"lineEndKey"];
    [defaults synchronize];
    
    [controller dismissPopUpViewControllerWithcompletion:nil];
}

#pragma mark - BLECommanderDelegate

//Called when a new device has been detected.
- (void)scanDelegate
{

}

- (void)connectionStateDelegate:(ConnectionState)newConnectionState
{
    switch (newConnectionState)
    {
        case DISCONNECTED:
            [self.delegate deviceConnectionDidTimeOut];
            break;
            
        case SCANNING:
            break;
            
        case CONNECTING:
            break;
            
        case INTERROGATING:
            break;
            
        case CONNECTED:
            break;
            
        case DISCONNECTING:
            break;
            
        default:
            break;
    }
}

- (void)busModeDelegate:(BusMode)newBusMode
{
    
}

- (void)dataReadDelegate:(NSData *) newData
{
    //Check mode, if stream then any data received will be from the computer/serial.
    
    if (self.mBleCommanderiOS.busMode == STREAM_MODE)
    {
        //Stream mode
        NSString *str = [[NSString alloc] initWithBytes:[newData bytes] length:newData.length encoding:NSUTF8StringEncoding];
        [self appendIncomingResponse:str];
    }
    else
    {
        NSString *str = [[NSString alloc] initWithBytes:[newData bytes] length:newData.length encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [NSString stringWithFormat:@"%@", str];

        //Command mode
        [self consoleAppend:str isIncomingFromDevice:false];
    }
}

- (void) dataWriteDelegate
{
    //Check mode, if stream then append data
    if (self.mBleCommanderiOS.busMode == STREAM_MODE)
    {
        //Stream mode
    }
    else
    {
        //Command mode
    }
    self.messageTextfield.text = nil;
}

- (void)dataParserDelegate:(Header)header payload:(NSString *)payload
{
    NSLog(@"Header:");
    NSLog(@"Type: %d", header.type);
    NSLog(@"Code: %d", header.code);
    NSLog(@"Length: %d", (unsigned int)header.length);
    
    NSLog(@"Payload: %@", payload);
}

@end
