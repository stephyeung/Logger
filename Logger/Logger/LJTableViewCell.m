//
//  LJTableViewCell.m
//  Logger
//
//  Created by Stephanie Yeung on 10/26/13.
//  Copyright (c) 2013 yeung.steph. All rights reserved.
//

#import "LJTableViewCell.h"

@implementation LJTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
