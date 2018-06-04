//
//  AppDelegate+pushNotification.h
//  WaveSampleApp
//
//  Created by KwanghoonKim on 2017. 6. 8..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "AppDelegate.h"
#import <WaveFramework/WaveFramework.h>

/**
 *
 * 01.클래스 설명 : PushNotification에 사용되는 Delegate 함수를 구성해 놓은 AppDelegate 카테고리 클래스
 * 02.제품구분 : External Source
 * 03.기능(콤퍼넌트) 명 : FIRMessagingDelegate,UNUserNotificationCenterDelegate 구현
 * 04.관련 기능 :
 * 05.수정이력<br>
 * <pre>
 * **********************************************************************************************************************************
 *  수정일                                                이름                          변경 내용
 * **********************************************************************************************************************************
 *  2017-06-19                                          김광훈                         최초 작성
 * **********************************************************************************************************************************
 *</pre>
 *
 * @author 김광훈
 * @version 1.0
 *
 */

@import FirebaseMessaging;

@interface AppDelegate (PushNotification)<FIRMessagingDelegate,UNUserNotificationCenterDelegate>


//@property NSData *wvDeviceToken;

@end
