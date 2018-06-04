//
//  ViewController.m
//  WaveSampleApp
//
//  Created by KwanghoonKim on 2017. 6. 9..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *pushAgreementSegmentControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnTouchEvent:(id)sender {
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token from View controller: %@", refreshedToken);
}
- (IBAction)pushAgreementValueChanged:(id)sender {
    
    NSString *serverURL;
    /*운영*/
    //serverURL= @"https://papi.bizlotte.com:8080/apis/";
    /*개발*/
     serverURL = @"http://210.93.181.227:8080/apis/";
    
    if(_pushAgreementSegmentControl.selectedSegmentIndex==1){
        /*device regist 시작*/
        [WVManager startWaveWithCustNo:@"5test0518" agentId:@"ldcctest" packageName:@"com.laboratory.ldcc.waveandroiddemo" url:serverURL deviveToken:NULL];
    }
    
        else if (_pushAgreementSegmentControl.selectedSegmentIndex==0){
            
            
        }
    
}
- (IBAction)btnGetUUID:(id)sender {
    
    NSString *uuid=  [WVManager getUUID];
    if (uuid) {
        NSLog(@"current uuid is : %@",uuid);
    }
}
- (IBAction)btnDeleteFCMToken:(id)sender {
    
    
    if( [WVManager stopWAVE]){
        NSLog(@"wave is stopped properly");
    }
    
}
- (IBAction)btnGetFcmToken:(id)sender {
    
    
    NSString *fcmToken=  [WVManager getFcmToken];
    if (fcmToken) {
        NSLog(@"current fcmtoken is : %@",fcmToken);
    }
}
- (IBAction)pushAgreeFromExistUser:(id)sender {
    
    
     [WVManager startWaveWithCustNo:@"custnoTest2" agentId:@"ldcctest2" packageName:@"kr.co.lottecinema.lcms" url:@"http://210.93.181.227:8080/apis/" deviveToken:NULL];}
- (IBAction)popupView:(id)sender {
    popup = [[PopupViewController alloc]init];
    [popup showInView:self.view animated:YES];
    
 
//    CustomPopupView *popup = [[CustomPopupView alloc]init];
//   
//      popup.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
//         popup.layer.cornerRadius = 5;
//         popup.layer.shadowOpacity = 0.8;
//         popup.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    [self.view addSubview:popup];

}


@end
