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
//  TimedOutViewController.m
//  BLE Commander
//
//  Created by Aaron Stephenson on 30/07/2015.
//  Copyright (c) 2015 Zentri. All rights reserved.
//

#import "TimedOutViewController.h"

@interface TimedOutViewController ()
@property (nonatomic, weak) IBOutlet UILabel *messageTitleLabel;
@property (nonatomic, weak) IBOutlet UITextView *messageBodyTextView;
@end

@implementation TimedOutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.messageTitleLabel.numberOfLines = 0;
    self.messageTitleLabel.text = self.errorTitle;
    self.messageBodyTextView.text = self.errorMessage;
    self.messageBodyTextView.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
