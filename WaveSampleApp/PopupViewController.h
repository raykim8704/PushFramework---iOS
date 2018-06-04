//
//  PopupViewController.h
//  WaveSampleApp
//
//  Created by KwanghoonKim on 2017. 7. 4..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *popupView;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
