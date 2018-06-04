//
//  CustomPopupView.m
//  WaveSampleApp
//
//  Created by KwanghoonKim on 2017. 7. 4..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "CustomPopupView.h"

@implementation CustomPopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame];
    if(self)
    {
        [self customInit];
    }
    return self;
}
-(void)customInit
{
    [[NSBundle mainBundle]loadNibNamed:@"popupView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}


@end
