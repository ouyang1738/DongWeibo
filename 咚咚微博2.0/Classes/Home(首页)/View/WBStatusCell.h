//
//  WBStatusCell.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/5.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBStatusFrame.h"


@interface WBStatusCell : UITableViewCell

@property(nonatomic,strong)WBStatusFrame *statusFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
