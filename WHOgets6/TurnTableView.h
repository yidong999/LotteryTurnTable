//
//  TurnTableView.h
//  WHOgets6
//
//  Created by 王雪利 on 15/8/24.
//  Copyright (c) 2015年 王雪利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurnTableView : UIView
@property (nonatomic,strong)NSMutableDictionary *cornerDic;

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary*)dataDic;
@end
