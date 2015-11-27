/*
 * Copyright 2014, ACKme Networks
 * All Rights Reserved.
 *
 * This is UNPUBLISHED PROPRIETARY SOURCE CODE of ACKme Networks;
 * the contents of this file may not be disclosed to third parties, copied
 * or duplicated in any form, in whole or in part, without the prior
 * written permission of ACKme Networks.
 */

#ifndef UUID_H
#define UUID_H

// UUIDs
// Normal UUIDs for iOS and reversed for FM


//SIG
#define CHARACTERISTIC_FIRMWARE_REVISION_STRING_UUID    @"2A26"
#define SERVICE_DEVICE_INFORMATION_UUID                 @"180A"

//TruConnect

#define SERVICE_TRUCONNECT_UUID                         @"175f8f23-a570-49bd-9627-815a6a27de2a"
#define UUID_SERVICE_TRUCONNECT                         0x2a, 0xde, 0x27, 0x6a, 0x5a, 0x81, 0x27, 0x96, 0xbd, 0x49, 0x70, 0xa5, 0x23, 0x8f, 0x5f, 0x17

#define CHARACTERISTIC_TRUCONNECT_PER_RX_UUID           @"1cce1ea8-bd34-4813-a00a-c76e028fadcb"
#define UUID_CHARACTERISTIC_TRUCONNECT_PER_RX           0xcb, 0xad, 0x8f, 0x02, 0x6e, 0xc7, 0x0a, 0xa0, 0x13, 0x48, 0x34, 0xbd, 0xa8, 0x1e, 0xce, 0x1c

#define CHARACTERISTIC_TRUCONNECT_PER_TX_UUID           @"cacc07ff-ffff-4c48-8fae-a9ef71b75e26"
#define UUID_CHARACTERISTIC_TRUCONNECT_PER_TX           0x26, 0x5e, 0xb7, 0x71, 0xef, 0xa9, 0xae, 0x8f, 0x48, 0x4c, 0xff, 0xff, 0xff, 0x07, 0xcc, 0xca

#define CHARACTERISTIC_TRUCONNECT_MODE_UUID             @"20b9794f-da1a-4d14-8014-a0fb9cefb2f7"
#define UUID_CHARACTERISTIC_TRUCONNECT_MODE             0xf7, 0xb2, 0xef, 0x9c, 0xfb, 0xa0, 0x14, 0x80, 0x14, 0x4d, 0x1a, 0xda, 0x4f, 0x79, 0xb9, 0x20


//OTA

#define SERVICE_OTA_UPGRADE_UUID                        @"b2e7d564-c077-404e-9d29-b547f4512dce"
#define UUID_SERVICE_OTA_UPGRADE                        0xce, 0x2d, 0x51, 0xf4, 0x47, 0xb5, 0x29, 0x9d, 0x4e, 0x40, 0x77, 0xc0, 0x64, 0xd5, 0xe7, 0xb2

#define CHARACTERISTIC_OTA_UPGRADE_CONTROL_POINT_UUID   @"48cbe15e-642d-4555-ac66-576209c50c1e"
#define UUID_CHARACTERISTIC_OTA_UPGRADE_CONTROL_POINT   0x1e, 0x0c, 0xc5, 0x09, 0x62, 0x57, 0x66, 0xac, 0x55, 0x45, 0x2d, 0x64, 0x5e, 0xe1, 0xcb, 0x48

#define CHARACTERISTIC_OTA_DATA_UUID                    @"db96492d-cf53-4a43-b896-14cbbf3bf4f3"
#define UUID_CHARACTERISTIC_OTA_UPGRADE_DATA            0xf3, 0xf4, 0x3b, 0xbf, 0xcb, 0x14, 0x96, 0xb8, 0x43, 0x4a, 0x53, 0xcf, 0x2d, 0x49, 0x96, 0xdb

#define CHARACTERISTIC_OTA_APP_INFO_UUID                @"ddcc1893-3e58-45a8-b9e5-491b7279d870"
#define UUID_CHARACTERISTIC_OTA_APP_INFO                0x70, 0xd8, 0x79, 0x72, 0x1b, 0x49, 0xe5, 0xb9, 0xa8, 0x45, 0x58, 0x3e, 0x93, 0x18, 0xcc, 0xdd

#endif //UUID_H
