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
//  StreamLineEndingViewController.m
//  BLE Commander
//
//  Created by Aaron Stephenson on 11/08/2015.
//  Copyright (c) 2015 Zentri. All rights reserved.
//

#import "StreamLineEndingViewController.h"
#import "UIViewController+ENPopUp.h"

@interface StreamLineEndingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation StreamLineEndingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.cellArray = [[NSMutableArray alloc]init];
    [self.cellArray addObject:@"None"];
    [self.cellArray addObject:@"CR"];
    [self.cellArray addObject:@"LF"];
    [self.cellArray addObject:@"CRLF"];
    [self.cellArray addObject:@"LFCR"];
    
    self.tableView.separatorColor = [UIColor colorWithWhite:0.400 alpha:1.000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.cellArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:0.722 green:0.722 blue:0.722 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.selectedIndex == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [self.delegate didSelectALineEnding:self];
    [tableView reloadData];
    
    [self dismissPopUpViewController];
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

@end
