//
//  Location.h
//  TicTacToeObjC
//
//  Created by Sasha Sheng on 5/14/15.
//  Copyright (c) 2015 Sasha Sheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Location : UIButton
@property (nonatomic, assign) NSInteger pawnType;
@property (nonatomic, assign) NSUInteger xLocation;
@property (nonatomic, assign) NSUInteger yLocation;
// 0 --> empty
// 1 --> x
// 2 --> o
@end
