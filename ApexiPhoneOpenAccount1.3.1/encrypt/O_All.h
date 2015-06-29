//
//  O_All.h
//  O_All
//
//  Created by YXCD on 13-9-9.
//  Copyright (c) 2013年 YXCD. All rights reserved.
//


#ifndef O_All_h
#define O_All_h


#include "type_def.h"


char * GetSystemDBDir();

// DB相对数据库 User相对用户
// 通过新的版本等信息生成新的密码
int itrus_Password_Generator_DB_New(OUT uchar * ptr_out_pwd_data,IN OUT uint * ptr_out_pwd_len, IN uchar * ptr_in_usr_pwd_data, IN uint in_usr_pwd_len);
// 通过旧的版本等信息生成新的密码
int itrus_Password_Generator_DB_Old(OUT uchar * ptr_out_pwd_data,IN OUT uint * ptr_out_pwd_len, IN uchar * ptr_in_usr_pwd_data, IN uint in_usr_pwd_len);

// 通过新的版本等信息生成新的密码
int itrus_Password_Generator_User_New(OUT uchar * ptr_out_pwd_data,IN OUT uint * ptr_out_pwd_len, IN uchar * ptr_in_usr_pwd_data, IN uint in_usr_pwd_len);
// 通过旧的版本等信息生成新的密码
int itrus_Password_Generator_User_Old(OUT uchar * ptr_out_pwd_data,IN OUT uint * ptr_out_pwd_len, IN uchar * ptr_in_usr_pwd_data, IN uint in_usr_pwd_len);

// 保存数据库新信息
int itrus_Save_Info_DB(IN uchar * ptr_in_usr_pwd_data, IN uint in_usr_pwd_len);

// 保存用户信息系
int itrus_Save_Info_User(IN uchar * ptr_in_usr_pwd_data, IN uint in_usr_pwd_len);

// 查看是否有旧信息数据库
int itrus_Has_Info_DB(int * bFlagExist);
// 查看是否有旧信息用户
int itrus_Has_Info_User(int * bFlagExist);

// 信息是否更新
int itrus_Info_User_IS_update(int * bFlagUpdate);
// 信息是否更新
int itrus_Info_DB_IS_update(int * bFlagUpdate);


// 是否有LICENSE
int itrus_Has_Info_License(int * bFlagExist);
// 保存LICENSE
int itrus_Save_Info_License(IN const char * ptr_license_name, IN const char * ptr_license_value);



#endif



