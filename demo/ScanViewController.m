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
//  ScanViewController.m
//  BLE Commander
//
//  Created by Aaron Stephenson on 1/07/2015.
//  Copyright (c) 2015 Zentri. All rights reserved.
//

#import "ScanViewController.h"
#import "DeviceDetailViewController.h"
#import "UIViewController+ENPopUp.h"
#import "BLECommanderiOS/BLECommanderiOS.h"
#import "TimedOutViewController.h"

@interface ScanViewController () <DeviceDetailViewControllerDelegate, BLECommanderDelegate>
@property (nonatomic, strong)BLECommanderiOS *mBleCommanderiOS;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *scanButton;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Configure TruConnect
    self.mBleCommanderiOS = [[BLECommanderiOS alloc] init];
    self.mBleCommanderiOS.delegate = self;
    
    [self setupViewAppearance];
}

- (void)setupViewAppearance
{
    //Setup the view and button appearance
    self.title = @"Scan for Devices";
    self.scanButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.scanButton.layer.borderWidth = 1;
    self.scanButton.layer.cornerRadius = 4;
    self.scanButton.clipsToBounds = true;
    [self.scanButton setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:95.0f/255.0f blue:34.0f/255.0f alpha:1]];
    [self.scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.110 green:0.114 blue:0.118 alpha:1];
    
    //Right navigation button
    UIImage *iconImage = [UIImage imageNamed:@"icon"];
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.bounds = CGRectMake(0, 0, 34, 34);
    [iconButton addTarget:self action:@selector(showAboutView:) forControlEvents:UIControlEventTouchUpInside];
    [iconButton setContentMode:UIViewContentModeScaleAspectFit];
    [iconButton setImage:iconImage forState:UIControlStateNormal];
    UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
    self.navigationItem.rightBarButtonItem = faceBtn;
    
    self.tableView.separatorColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    self.tableView.rowHeight = 60;
    
    //Configure the TableView cell separator insets
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

- (void)showAboutView:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AboutView"];
    vc.view.frame = CGRectMake(0, 0, 270.0f, 290.0f);
    [self presentPopUpViewController:vc];
}

- (void)showAlert:(NSString *)title withBody:(NSString *)body
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TimedOutViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"TimeOut"];
    vc.errorMessage = body;
    vc.errorTitle = title;
    vc.view.frame = CGRectMake(0, 0, 270.0f, 290.0f);
    [self presentPopUpViewController:vc completion:^{
        [self startScanning];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Configure Delegate
    self.mBleCommanderiOS.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Start Scanning
    [self startScanning];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)startScanning
{
    [self stopScanning];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(stopScanning) userInfo:nil repeats:false];

    //Start Scanning
    BOOL didStartScanning = [self.mBleCommanderiOS startScan];
    self.title = @"Scanning";
    self.scanButton.enabled = false;
    [self.scanButton setTitle:@"Scanning" forState:UIControlStateNormal];
    [self.scanButton setBackgroundColor:[UIColor whiteColor]];
    [self.scanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = true;
    [self.tableView reloadData];
}

- (void)stopScanning
{
    //Stop Scanning
    [self.mBleCommanderiOS stopScan];
    [self.tableView reloadData];
    self.title = @"Scan for Devices";
    self.scanButton.enabled = true;
    [self.scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    [self.scanButton setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:95.0f/255.0f blue:34.0f/255.0f alpha:1]];
    [self.scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = false;
}

- (void)disconnectFromDevice
{
    //Disconnect from device
    [self.mBleCommanderiOS disconnect];
    [self.tableView reloadData];
    self.title = @"Scan for Devices";
    [self.scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = false;
}

- (void)connectionTimeout
{
    [self showAlert:@"Timed out" withBody:@"The connection timed out. Please try again"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDeviceDetail"])
    {
        DeviceDetailViewController *tmpView = segue.destinationViewController;
        tmpView.delegate = self;
        tmpView.mBleCommanderiOS = self.mBleCommanderiOS;
        tmpView.deviceName = [[[self.mBleCommanderiOS.devicesDiscovered objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"adv"] valueForKey:CBAdvertisementDataLocalNameKey];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:false];
    }
}

//Scan button pressed
- (IBAction)scanForDevices:(id)sender
{
    switch (self.mBleCommanderiOS.connectionState)
    {
        case DISCONNECTED:
        {
            //Start Scanning
            [self startScanning];
            break;
        }
        case SCANNING:
        {
            //Stop Scanning
            [self stopScanning];
            break;
        }
        case CONNECTING:
        case INTERROGATING:
        case CONNECTED:
        {
            //Disconnect from device
            [self disconnectFromDevice];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mBleCommanderiOS.devicesDiscovered count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    NSString *deviceName = [NSString stringWithFormat:@"%@",[[[self.mBleCommanderiOS.devicesDiscovered objectAtIndex:indexPath.row] valueForKey:@"adv"] valueForKey:CBAdvertisementDataLocalNameKey]];
    if ([deviceName isEqualToString:@"(null)"])
    {
        cell.textLabel.text = @"Unnamed Device";
    }
    else
    {
        cell.textLabel.text = deviceName;
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:95.0f/255.0f blue:34.0f/255.0f alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.timer invalidate];
    
    self.scanButton.enabled = false;
    [self.mBleCommanderiOS connectToDevice:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Configure the TableView cell separator insets
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - DeviceDetailViewControllerDelegate

- (void)deviceConnectionDidTimeOut
{
    [self.navigationController popToRootViewControllerAnimated:true];
    [self showAlert:@"Connection Lost" withBody:@"The connection to the device was lost. Please try reconnecting."];
}

#pragma mark - BLECommanderDelegate

//Called when a new device has been detected.
- (void)scanDelegate
{
    [self.tableView reloadData];
}

//Called when the connection state has changed.
- (void)connectionStateDelegate:(ConnectionState)newConState
{
    switch (newConState)
    {
        case DISCONNECTED:
            [self stopScanning];
            break;
            
        case SCANNING:
            [self.scanButton setTitle:@"Scanning" forState:UIControlStateNormal];
            [self.tableView reloadData];
            break;
            
        case CONNECTING:
            [self.scanButton setTitle:@"Connecting" forState:UIControlStateNormal];
            [self.scanButton setBackgroundColor:[UIColor whiteColor]];
            [self.scanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
            
        case INTERROGATING:
            [self.scanButton setTitle:@"Interrogating" forState:UIControlStateNormal];
            [self.scanButton setBackgroundColor:[UIColor whiteColor]];
            [self.scanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
            
        case CONNECTED:
        {
            [self.scanButton setTitle:@"Connected" forState:UIControlStateNormal];
            [self.scanButton setBackgroundColor:[UIColor whiteColor]];
            [self.scanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self performSegueWithIdentifier:@"showDeviceDetail" sender:self];
            
            //Stop scanning
            [self stopScanning];
            break;
        }
            
        case DISCONNECTING:
            [self.scanButton setTitle:@"Disconnecting" forState:UIControlStateNormal];
            [self.scanButton setBackgroundColor:[UIColor whiteColor]];
            [self.scanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
            
        case CONNECTIONTIMEDOUT:
            [self connectionTimeout];
            break;
            
        default:
            break;
    }
}

//Called when the bus mode has changed.
- (void)busModeDelegate:(BusMode)newBusMode
{
    
}

//Called when data has been read from the pheripheral.
- (void) dataReadDelegate:(NSData *) newData
{
    
}

//Called when data has been written to the device.
- (void) dataWriteDelegate
{

}

- (void) dataParserDelegate:(Header)header payload:(NSString *)payload
{
    NSLog(@"Header:");
    NSLog(@"Type: %d", header.type);
    NSLog(@"Code: %d", header.code);
    NSLog(@"Length: %d", (unsigned int)header.length);
    
    NSLog(@"Payload: %@", payload);
}

@end
