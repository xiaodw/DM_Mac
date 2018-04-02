//
//  UrlConfig.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/4/2.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#ifndef UrlConfig_h
#define UrlConfig_h

#if 0 //测试环境
#define URL_GET_APP_CONFIG @"http://test.api.cn.discovermelody-app.com/init/getPCConfig"
#define URL_GET_USER_INFO @"http://test.api.cn.discovermelody-app.com/User/loginPc"
#define URL_GET_LESSON_INFO_STUDENT @"http://test.api.cn.discovermelody-app.com/Lesson/studentAccess"
#define URL_GET_LESSON_INFO_TEACHER @"http://test.api.cn.discovermelody-app.com/Lesson/teacherAccess"
#define URL_REPORT_AGORA_LOG @"http://test.api.cn.discovermelody-app.com/Log/agoraLog"
#else //线上环境
#define URL_GET_APP_CONFIG @"http://api.cn.discovermelody-app.com/init/getPCConfig"
#define URL_GET_USER_INFO @"http://api.cn.discovermelody-app.com/User/loginPc"
#define URL_GET_LESSON_INFO_STUDENT @"http://api.cn.discovermelody-app.com/Lesson/studentAccess"
#define URL_GET_LESSON_INFO_TEACHER @"http://api.cn.discovermelody-app.com/Lesson/teacherAccess"
#define URL_REPORT_AGORA_LOG @"http://api.cn.discovermelody-app.com/Log/agoraLog"
#endif

#endif /* UrlConfig_h */
