# BLE Commander iOS Demo
This appliaction demonstrates how to use the Zentri BLE iOS Framework

# Installation
To install the Framework in your own applications, drag the file "BLECommander.Framework" from this Xcode project to yours ensuring that you select "Copy if needed"

# Usage
This demo app uses the Framework to handle the communications to Zentri BLE devices. The Framework returns data to the calling code via delegate call back methods that are triggered when events occur within the Framework.
###Header
Add the delegate protocol code to your .h file

```
	@interface UIViewController : UIViewController <BLECommanderDelegate>
```
###Implementation
The following are examples of code to add to your .m file and how to use the framework.

```
	#import "BLECommanderiOS/BLECommanderiOS.h"

	//setup BLE Commander object
	BLECommanderiOS *mBleCommanderiOS = [[BLECommanderiOS alloc] init];
    mBleCommanderiOS.delegate = self;
    
    //start scanning
    [mBleCommanderiOS startScan];
    
    //Stop Scanning
    [mBleCommanderiOS stopScan];
    
    //Number of BLE Devices discovered
    [mBleCommanderiOS.devicesDiscovered count];
    
    //connect to a device
    NSString *deviceName = [NSString stringWithFormat:@"%@",
                            [[[self.mBleCommanderiOS.devicesDiscovered objectAtIndex:indexPath.row]
                              valueForKey:@"adv"]
                             valueForKey:CBAdvertisementDataLocalNameKey]];
                             
    [mBleCommanderiOS connectToDevice:deviceName];
    
    
    //Disconnect from device
    [mBleCommanderiOS disconnect];
```

###Delegate Callback Methods
Below are all the required delegate callback methods that need to be implemented when using the Framework.

```
/**
 Delegate method advising whent he connection state has changed and the new connection state
 @params newConnectionState: ConnectionState of the current connection
 */
- (void)connectionStateDelegate:(ConnectionState)newConnectionState;

/**
 Delegate method used whe the bus mode changes
 @params newBusMode: the new bus mode for the connection
 */
- (void)busModeDelegate:(BusMode)newBusMode;

/**
 Delegate method used when the device has new data to read.
 @params newData: updated values
 */
- (void)dataReadDelegate:(NSData *) newData;

/**
 Delegate method used to advise that the data has been written
 */
- (void)dataWriteDelegate;

/**
 Delegate method called when a device is discovered
 */
- (void)scanDelegate;

/**
 Delegate method for parsed data.
 @param header: packet header
 @param payload: packet payload
 */
- (void)dataParserDelegate:(Header)header payload:(NSString *)payload;

```

# License
Copyright (C) 2015, Zentri, Inc. All Rights Reserved.

The Zentri BLE iOS Framework and Zentri BLE example applications are provided free of charge by Zentri. The combined source code, and all derivatives, are licensed by Zentri SOLELY for use with devices manufactured by Zentri, or devices approved by Zentri.

Use of this software on any other devices or hardware platforms is strictly prohibited. THIS SOFTWARE IS PROVIDED BY THE AUTHOR AS IS AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
