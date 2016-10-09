//
//  GlobalDefinition.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#ifndef GlobalDefinition_h
#define GlobalDefinition_h


// --------------------------------------------------------------------------------------------------------
#define UI_Window    [[[UIApplication sharedApplication] delegate] window] //获得window
#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height          //包含状态bar的高度(e.g. 480)
#define kApplicationSize      [[UIScreen mainScreen] applicationFrame].size       //(e.g. 320,460)
#define kApplicationWidth     [[UIScreen mainScreen] applicationFrame].size.width //(e.g. 320)
#define kApplicationHeight    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)
#define kNavigationBarHeight  64


// ---------------------------------------------------------------------------------------------------------
#define HTTP_KEY_RESULTCODE     @"retCode"       //http请求resultcode Key
#define HTTP_KEY_RESULTMESSAGE  @"retMsg"        //http请求resultMsg Key

#define HTTP_RESULTCODE_SUCCESS         @"000"      //http请求resultcode 成功
#define HTTP_RESULTCODE_ERROR           @"001"      //http请求resultcode 失败

// ---------------------------------------------------------------------------------------------------------

// 注册
#define ID_REGISTER             1001
#define URL_REGISTER            @"http://112.74.100.227:8083/rest/moli/regist"
// 短信验证码
#define ID_GET_PHONE_MSG_CODE   1002
#define URL_GET_PHONE_MSG_CODE  @"http://112.74.100.227:8083//rest/moli/send-msg"
// 登陆
#define ID_LOGIN                1003
#define URL_LOGIN               @"http://112.74.100.227:8083/rest/moli/login"





#endif /* GlobalDefinition_h */
