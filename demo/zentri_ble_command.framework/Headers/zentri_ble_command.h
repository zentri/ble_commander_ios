/* BLE Commander iOS Library & Example Applications
 *
 * Copyright (C) 2015, Sensors.com,  Inc. All Rights Reserved.
 *
 * The BLE Commander iOS Library and BLE Commander example applications are provided free of charge by
 * Sensors.com. The combined source code, and all derivatives, are licensed by Sensors.com SOLELY
 * for use with devices manufactured by Zentri, or devices approved by Sensors.com.
 *
 * Use of this software on any other devices or hardware platforms is strictly prohibited.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AS IS AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

//Commands
#define TC_COM_ADC                          @"adc"
#define TC_COM_BEEP                         @"beep"
#define TC_COM_FACTORY_RESET                @"fac"
#define TC_COM_GET                          @"get"
#define TC_COM_GPIO_DIRECTION               @"gdi"
#define TC_COM_GPIO_FUNCTION                @"gfu"
#define TC_COM_GPIO_GET                     @"gge"
#define TC_COM_GPIO_SET                     @"gse"
#define TC_COM_PWM                          @"pwm"
#define TC_COM_REBOOT                       @"reboot"
#define TC_COM_SAVE                         @"save"
#define TC_COM_SET                          @"set"
#define TC_COM_SLEEP                        @"sleep"
#define TC_COM_STREAM_MODE                  @"str"
#define TC_COM_VERSION                      @"ver"

//Variables
#define TC_VAR_BLUETOOTH_ADDRESS            @"bl a"
#define TC_VAR_BLUETOOTH_CON_COUNT          @"bl c c"
#define TC_VAR_BLUETOOTH_SERVICE_UUID       @"bl s u"
#define TC_VAR_BLUETOOTH_TX_POWER_ADV       @"bl t a"
#define TC_VAR_BLUETOOTH_TX_POWER_CON       @"bl t c"
#define TC_VAR_BLUETOOTH_ADV_MODE           @"bl v m"
#define TC_VAR_BLUETOOTH_ADV_HIGH_DUR       @"bl v h d"
#define TC_VAR_BLUETOOTH_ADV_HIGH_INT       @"bl v h i"
#define TC_VAR_BLUETOOTH_ADV_LOW_DUR        @"bl v l d"
#define TC_VAR_BLUETOOTH_ADV_LOW_INT        @"bl v l i"
#define TC_VAR_BUS_INIT_MODE                @"bu i"
#define TC_VAR_BUS_SERIAL_CONTROL           @"bu s c"
#define TC_VAR_CENTRAL_CON_COUNT            @"ce c c"
#define TC_VAR_CENTRAL_CON_MODE             @"ce c m"
#define TC_VAR_CENTRAL_SCAN_HIGH_DUR        @"ce s h d"
#define TC_VAR_CENTRAL_SCAN_HIGH_INT        @"ce s h i"
#define TC_VAR_CENTRAL_SCAN_LOW_DUR         @"ce s l d"
#define TC_VAR_CENTRAL_SCAN_LOW_INT         @"ce s l i"
#define TC_VAR_CENTRAL_SCAN_MODE            @"ce s m"
#define TC_VAR_GPIO_USAGE                   @"gp u"
#define TC_VAR_SYSTEM_ACTIVITY_TIMEOUT      @"sy a t"
#define TC_VAR_SYSTEM_BOARD_NAME            @"sy b n"
#define TC_VAR_SYSTEM_COMMAND_ECHO          @"sy c e"
#define TC_VAR_SYSTEM_COMMAND_HEADER        @"sy c h"
#define TC_VAR_SYSTEM_COMMAND_PROMPT        @"sy c p"
#define TC_VAR_SYSTEM_COMMAND_MODE          @"sy c m"
#define TC_VAR_SYSTEM_DEVICE_NAME           @"sy d n"
#define TC_VAR_SYSTEM_INDICATOR_STATUS      @"sy i s"
#define TC_VAR_SYSTEM_OTA_ENABLE            @"sy o e"
#define TC_VAR_SYSTEM_PRINT_LEVEL           @"sy p"
#define TC_VAR_SYSTEM_REMOTE_COMMAND_ENABLE @"sy r e"
#define TC_VAR_SYSTEM_GO_TO_SLEEP_TIMEOUT   @"sy s t"
#define TC_VAR_SYSTEM_UUID                  @"sy u"
#define TC_VAR_SYSTEM_VERSION               @"sy v"
#define TC_VAR_SYSTEM_WAKE_UP_TIMEOUT       @"sy w t"
#define TC_VAR_UART_BAUD_RATE               @"ua b"
#define TC_VAR_UART_FLOW_CONTROL            @"ua f"
#define TC_VAR_USER_VARIABLE                @"us v"

typedef enum
{
    DISCONNECTED,
    SCANNING,
    CONNECTING,
    INTERROGATING,
    CONNECTED,
    DISCONNECTING,
    CONNECTIONTIMEDOUT
} ConnectionState;

typedef enum
{
    UNKNOWN_MODE = 0,
    STREAM_MODE,
    LOCAL_COMMAND_MODE,
    REMOTE_COMMAND_MODE,
    UNSUPPORTED_MODE
} BusMode;

typedef enum
{
    RESPONSE,
    LOG
} HeaderType;

typedef enum
{
    SUCCESS,
    COMMAND_FAILED,
    PARSE_ERROR,
    UNKNOWN_COMMAND,
    TOO_FEW_ARGS,
    TOO_MANY_ARGS,
    UNKNOWN_VARIABLE_OR_OPTION,
    INVALID_ARGUMENT
} ErrorCode;

typedef struct
{
    HeaderType type;
    UInt8 code;
    UInt32 length;
} Header;

@protocol BLECommanderDelegate <NSObject>
@required
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
@end

@interface BLECommanderiOS : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic, weak) id <BLECommanderDelegate> delegate;
@property(nonatomic, strong) NSString *firmwareVersion;
@property(nonatomic, strong) NSMutableArray *devicesDiscovered;
@property(nonatomic, assign) ConnectionState connectionState;
@property(nonatomic, assign) BusMode busMode;

/**
 Call this method to start scanning for devices
 
 @return Boolean value to indicate if scanning has started
 */
- (BOOL)startScan;

/**
 Call this method to stop scanning for devices
 
 @return Boolean value to indicate if scanning has stopped
 */
- (BOOL)stopScan;

/**
 Method to connect to a device
 
 @param deviceName: The name of the device you wish to connect to
 
 @return Boolean value to indicate if there has been a successful connection to the device
 */
- (BOOL)connectToDevice:(NSString *)deviceName;

/**
 Method used to disconnect from a device.
 */
- (BOOL)disconnect;


/**
 Method used to read the BusMode for a device eg Stream, Local or Remote commands
 
 @return Boolean value, FALSE if not connected else TRUE.
 */
- (BOOL)readBusMode;


/**
 Method used to write new bus mode for device
 
 @param newBusMode: The new BusMode for the device
 
 @return Boolean value, FALSE if not connected or BusMode not changed. TRUE if BusMode written.
 */
- (BOOL)writeBusMode:(BusMode)newBusMode;


/**
 Method to see if you can write to the device.
 
 @return Boolean value, TRUE if device is connected and no data waiting to be written to the device, else FALSE.
 */
- (BOOL)canWrite;

/**
 Method used to write data to a device.
 
 @param data: Data to be writted to device.
 
 @return Boolean value advising if the data has been written to the device or not.
 */
- (BOOL)writeData:(NSData *)data;

/**
 Method used to write strings to devcice.
 
 @param string: String value to be writted to device.
 
 @return Boolean value advising if the string has been written to the device or not.
 */
- (BOOL)writeString:(NSString *)string;

/**
 Method used to send commands to the device
 
 @param command: Command
 @param args: Arguments
 
 @return Boolean value advising if the command has been written to the device or not.
 */
- (BOOL)sendCommand:(NSString *)command args:(NSString *)args;


/**
 Method used to parse the data returned from the device
 
 @param data: The data to be parsed
 
 @return Boolean value advising if the data has been parsed successfully or not.
 */
- (BOOL)dataParser:(NSData *)data;
@end
