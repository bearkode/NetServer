/*
 *  BKTypes.h
 *  NetServer
 *
 *  Created by bearkode on 2015. 4. 14..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#ifndef NetServer_BKTypes_h
#define NetServer_BKTypes_h


typedef NS_ENUM(NSInteger, BKPositionType)
{
    BKPositionInBox = 0,
    BKPositionOverBox,
    BKPositionUnderBox,
    BKPositionLeftOfBox,
    BKPositionRightOfBox,
    BKPositionFrontOfBox,
    BKPositionBackOfBox
};


typedef NS_ENUM(NSInteger, BKEventType)
{
    BKEventTypeUnknown = 0,
    BKEventTypeOnline,
    BKEventTypeOffline,
    BKEventTypeEnterBox,
    BKEventTypeLeaveBox,
    BKEventTypeStandby,
    BKEventTypeSwipe,
    BKEventTypeUpDown,
    BKEventTypeClasp,
    BKEventTypeCount
};


#endif
