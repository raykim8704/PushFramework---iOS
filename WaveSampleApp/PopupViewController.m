//
//  PopViewController.m
//  WaveSampleApp
//
//  Created by KwanghoonKim on 2017. 7. 3..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()


@end

@implementation PopupViewController


-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self =[super initWithCoder:aDecoder]){
        [[NSBundle mainBundle]loadNibNamed:@"PopupViewController" owner:self options:nil];
        [self.popupView addSubview:self.view];
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    //    self.popUpView.layer.cornerRadius = 5;
    //    self.popUpView.layer.shadowOpacity = 0.8;
    //    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popupView.layer.cornerRadius =5;
    self.popupView.layer.shadowOpacity = 0.8;
    self.popupView.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
}
- (IBAction)closePopup:(id)sender {
    
    [self removeAnimate];
}




@end
