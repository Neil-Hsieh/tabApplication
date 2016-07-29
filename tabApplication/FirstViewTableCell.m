//
//  FirstViewTableCell.m
//  tabApplication
//
//  Created by KevinShen on 2016/6/23.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "FirstViewTableCell.h"
#import "UIView+SDAutoLayout.h"
@implementation FirstViewTableCell
- (void)awakeFromNib {

    self.imageT.sd_layout
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthRatioToView(self.contentView, 0.3)
    .leftSpaceToView(self.contentView,20);
    
   
//
////    UILabel *textLabel = [[UILabel alloc] init];
////    textLabel.textColor = [UIColor blackColor];
////    textLabel.font = [UIFont systemFontOfSize:24];
////    textLabel.text = @"aaa";
////    [self.contentView addSubview:textLabel];
//////    self.textLabel = textLabel;
//    self.textLabel.sd_layout
//    .topSpaceToView(self.contentView,5)
//    .rightSpaceToView(self.contentView,50)
//    .heightIs(26);
//
//    self.contentView.backgroundColor = [UIColor blueColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
