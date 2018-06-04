//
//  WVDefines.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 12..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#ifndef WVDefines_h
#define WVDefines_h



#define DATABASE_FOR_WAVE  @"waveDatabase.sqlite" //wave 내부(sqlite) database 명
#define TABLE_NAME_FOR_USER @"userInfo" //userinfo Table명
#define TABLE_NAME_FOR_RECEIVE_DOCID @"receivedocid"
#define TABLE_NAME_FOR_OPEN_DOCID @"opendocid"

#define SDK_VER @"0.8.6"
#define OS_TYPE_CODE @"2"
//#define WAVE_PACKAGENAME @"com.laboratory.ldcc.waveandroiddemo"

//#define API_DOMAIN  @"http://210.93.181.131:8080/apis/"// wave API서버

#define API_SUFFIX_REGISTRATION @"registration"
#define API_SUFFIX_OPEN @"open"
#define API_SUFFIX_RECIEVE @"receive"

#define UUID_LENGTH 48 //uuid 생성 시 길이
#define TABLE_DOCID_MAX_ROW 50 //docid table max row count

typedef NS_ENUM(NSInteger,WAVE_APIS){
    WAVE_DEVICE_REGISTRATION,
    WAVE_OPEN,
    WAVE_RECIEVE
};




#endif /* WVDefines_h */
