//
//  AppDelegate+pushNotification.m
//  WaveSampleApp
//
//  Created by KwanghoonKim on 2017. 6. 8..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "AppDelegate+PushNotification.h"
#import "popupViewController.h"

@implementation AppDelegate (PushNotification)



#pragma Wave methods


/*  Related with Token registration */
/**
 *
 * 01.함수 설명 :FIRMessagingDelegate 함수
 * 02.제품구분 : PushNotification Category Clss
 * 03.기능(콤퍼넌트) 명 : FCM으로 부터 fcmToken을 수신 받았을때, 발생하는 함수
 * 04.관련 기능 : WVManager deiveRegistrationWithFcmToken
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

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
     [WVManager deviceRegistrationWithFcmToken:fcmToken deviceToken:NULL];
    // Connect to FCM since connection may have failed when attempted before having a token.
    //[self connectToFcm];
    
   
    // TODO: If necessary send token to application server.
    
}



/**
 *
 * 01.함수 설명 :UIApplication Delegate 함수
 * 02.제품구분 : PushNotification Category Clss
 * 03.기능(콤퍼넌트) 명 : RemoteNotification등록에 실패 했을 경우, 발생되는 함수
                      알려진 에러 CODE =3000 (project -> capabilities -> Push Notification [OFF])
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
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
    
}


- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    
    
    // TODO: If necessary send token to application server.
}

/**
 *
 * 01.함수 설명 :UIApplication Delegate 함수
 * 02.제품구분 : PushNotification Category Clss
 * 03.기능(콤퍼넌트) 명 : RemoteNotification등록에 성공하고, deviceToken을 정상적으로 수신받았을 경우 발생하는 함수
 * 04.관련 기능 : [FIRMessaging messaging] setAPNSToken , [WVManager sharedInstance]setDeviceToken
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // With "FirebaseAppDelegateProxyEnabled": NO

    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeProd];

        
    NSLog(@"device Token info : %@",deviceToken);
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token when device token retrieves: %@", refreshedToken);
    
    [WVManager deviceRegistrationWithFcmToken:NULL deviceToken:deviceToken];
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    //    if (userInfo[kGCMMessageIDKey]) {
    //        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    //    }
    //
    // Print full message.
    NSLog(@"%@", userInfo);
}

/**
 *
 * 01.함수 설명 :UIApplication Delegate 함수
 * 02.제품구분 : PushNotification Category Clss
 * 03.기능(콤퍼넌트) 명 : iOS 9 이하에서, Foreground -> PushNotification을 받았을 경우 또는 Background -> Notification 누름 -> 앱 진입 했을 경우 발생하는 함수
 * 04.관련 기능 : [WVManager recieceMessageFromForeground:userInfo]
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    [WVManager receiveMessage:userInfo];
    NSLog(@"background fetch :  %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}


/**
 *
 * 01.함수 설명 :UNUserNotificationCenter Delegate 함수
 * 02.제품구분 : PushNotification Category Clss
 * 03.기능(콤퍼넌트) 명 : iOS 10 이상에서, Foreground -> PushNotification을 받았을 경우 발생하는 함수
 * 04.관련 기능 : [WVManager recieceMessageFromForeground:userInfo]
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

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"포어그라운드 상태에서 푸시를 받을경우 집입되는 함수");

    completionHandler(UNNotificationPresentationOptionAlert);
    
    NSLog(@"userInfo Data : %@",userInfo);
    [WVManager receiveMessage:userInfo];
    
    NSLog(@"userInfo Data , uuid :%@",[userInfo objectForKey:@"uuid"]);
//    PopupViewController *popupView = [[PopupViewController alloc]init];
//    UIWindow *topWindow = [[UIApplication sharedApplication]keyWindow];
//    [popupView showInView:self.window animated:YES];
    
    
}

/**
 *
 * 01.함수 설명 :UNUserNotificationCenter Delegate 함수
 * 02.제품구분 : PushNotification Category Clss
 * 03.기능(콤퍼넌트) 명 : iOS 10 이상에서, Background -> Notification 선택 -> 앱진입 했을 경우 발생하는 함수
 * 04.관련 기능 : [WVManager recieceMessageFromForeground:userInfo]
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


// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"백그라운드에서 노티를 클릭하여 앱으로 진입 했을경우 호출 되는 함수");
    NSLog(@"userInfo Data : %@",userInfo);
    [WVManager receiveMessage:userInfo];
    [WVManager openMessage:userInfo];
    
}




- (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage
{
    NSLog(@"applcation Recieved remote message %@ : ",remoteMessage);
}


// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
/******************** CAN BE Removed ***********************/
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}
// [END ios_10_data_message]

@end
