//
//  functioninterface.h
//  O_All
//
//  Created by YXCD on 13-9-11.
//  Copyright (c) 2013年 YXCD. All rights reserved.
//

#ifndef O_All_func_def_h
#define O_All_func_def_h

#include "type_def.h"

@class userInfo;


/*
 功能名称:  初始化webservices和accounthash
 函数名称:  initWebsiteAndAccountHash
 输入参数:  AccountHash 类型 string
            Website 类型 string
 输出参数: 
 返回值:   成功：0
 失败：错误码
 功能描述: 初始化webservices和accounthash
 */
int initWebsiteAndAccountHash(IN const NSString * str_website,IN const NSString * str_accounthash);

/*
 功能名称:  获取最后一次错误信息
 函数名称:  initWebsiteAndAccountHash
 输入参数:  
 
 输出参数:  最后一次错误信息  类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 获取最后一次错误信息
 */
int getLastErrInfo(OUT NSString * * str_last_error);

/*
 功能描述: 内部调用
 */
int setLastErrInfo(IN int err_code);

//证书唯一标识说明
//在移动终端上应用的数字证书,根据不同的存储方式分为: 软件证书:存储在移动终端的系统证书库中; 文件证书:存储在移动终端的TF卡中指定路径下,已加密文件形式存储; 硬件证书:存储在支持移动终端接入的硬件加密介质Key中; 证书唯一标识的定义规则: 第1位:S代表文件/软证书,H代表硬件证书;
//第2位:“_”作为分隔符; 第3至22位:20位随机数或者对于主题等信息的摘要值。 例如:“S_12345678901234567890”或“H_12345678900987654321”。



/*
 功能名称:  申请证书Old
 函数名称:  enrollCert 
 输入参数:  用户信息   类型userinfo
            是否自动审批证书 类型 int，如果该值为0表示手工申请，需要调用3.1.2的方法获取证书。1表示自动审批，证书通过参数返回。
 输出参数:  证书字符串编码（base64格式）  类型 string，如果第二项输入参数为0，则参数返回null。如果第二项输入参数为1，则本参数返回证书字符串编码。
 返回值:   成功：0
            失败：错误码
 功能描述: 用户提交申请信息到RA中心申请证书
 */
int enrollCertOld(OUT NSString * * str_certificate, IN const userInfo * ptr_user_info, IN const NSString * str_aaPassPort, const NSString * str_certReqChallenge, IN int i_auto_approval_certificate);

/*
 功能名称:  申请证书
 函数名称:  enrollCert
 输入参数:  用户信息   类型userinfo
           证书请求Base64编码
 是否自动审批证书 类型 int，如果该值为0表示手工申请，需要调用3.1.2的方法获取证书。1表示自动审批，证书通过参数返回。
 输出参数:  证书字符串编码（base64格式）  类型 string，如果第二项输入参数为0，则参数返回null。如果第二项输入参数为1，则本参数返回证书字符串编码。
 返回值:   成功：0
 失败：错误码
 功能描述: 用户提交申请信息到RA中心申请证书
 */
int enrollCert(OUT NSString * * str_certificate,IN const NSString * str_CSR, IN const userInfo * ptr_user_info, IN const NSString * str_aaPassPort, const NSString * str_certReqChallenge, IN int i_auto_approval_certificate);


/*
 功能名称:  下载证书
 函数名称:  pickupCert
 输入参数:  私钥保护口令，该口令需要与userinfo.certReqChallenge的值相同   类型 string 
           用户申请批准后的PIN码 类型 string
 输出参数:  证书字符串编码（base64格式）  类型 string
 返回值:   成功：0
            失败：错误码
 功能描述: 管理员在PC上审批用户提交的请求,然后会通过邮 件发送PIN码到用户手中,用户拿到PIN码后,使用 PIN码向RA中心下载证书。
 */

int pickupCert(OUT NSString * * str_certificate, IN const NSString * str_certPin, IN const NSString * str_certReqChallenge);

/*
 功能名称:  更新证书
 函数名称:  renewCert
 输入参数:  证书更新信息   类型renewinfo
 输出参数:  证书字符串编码（base64格式）  类型 string
 返回值:   成功：0
            失败：错误码
 功能描述: 输入用户参数后直接能下载到证书，不需要管理员进行审批。
 */
int renewCert(OUT NSString * * str_certificate, IN const renewInfo * ptr_renew_info);


/*
 功能名称:  吊销证书
 函数名称:  revokeCert
 输入参数:  证书序列号 类型 string
            吊销理由码 类型 string
            私钥保护口令 类型 string,该口令需要与 userinfo.certReqChallenge的值相同
 返回值:   成功：0
            失败：错误码
 功能描述: 因为某种原因需要吊销证书,根据证书序列号进行 证书吊销。
 */
int revokeCert(IN const NSString * str_cert_serial_number, IN const NSString * str_revocation_reason_code,IN const NSString * str_pri_pwd);


/*
 功能名称:  证书状态查询
 函数名称:  getEnrollStatus
 输入参数:  姓名 类型 string 
           电子邮件 类型 string 
           查询开始时间 类型 string 
           查询结束时间 类型 string
 输出参数:  查询到的状态(申请中:PENDING;待下载: PICKUP;有效:VALID ;已吊销:REVOKE;挂 起:SUSPEND) 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 查询规定的时间段内的管理员审批证书情况。
 */
int getEnrollStatus(OUT NSString * * str_status, IN const NSString * str_name, IN const NSString * str_emial,IN const NSString * str_time_start, IN const NSString * str_time_stop);


/*
 功能名称:  证书过滤
 函数名称:  filterCert
 输入参数:  颁发者主题 类型 string (缺省为"")
            证书序列号 类型 string (缺省为"")
            证书主题 类型 string (缺省为"",可以为主题DN 中的某一项值或完成DN值)
            证书状态 类型 int (缺省为0,0表示所有证书,1 表示处于有效期内的证书,2表示待更新证书,3表示未生效或已过期证书)
            待更新证书天数 类型 int (缺省为30,只在证书状 态为2时本参数才有效)
            介质类型 类型 int(缺省为0,0表示所有证书,1 表示文件/软证书,2表示硬件证书)
 输出参数:  证书唯一标识,计数从0开始 类型 string[]
 返回值:   成功：0
 失败：错误码
 功能描述: 根据证书的颁发者、序列号、主题(或主题中某 项)、证书状态,过滤符合条件的证书。
 */
int filterCert(OUT NSMutableArray * * str_cert_id , IN const NSString * str_issuer_theme, IN const NSString * str_cert_serial_number,IN const NSString * str_cert_theme, IN int i_cert_status, IN int i_cert_update_remain_days);


/*
 功能名称:  证书到期提醒
 函数名称:  certExpireRemind
 输入参数:  证书唯一标识 类型 string
 输出参数:  即将到期的时间 类型 int*
 返回值:   成功：0
 失败：错误码
 功能描述: 对比证书的有效期截至时间和本地服务器时间,计算剩余的时间进行提醒。
 */
int certExpireRemind(OUT int * str_time_remind, IN const NSString * str_cert_id);


/*
 功能名称:  证书主题查看
 函数名称:  getCertSubject
 输入参数:  证书唯一标识 类型 string
 输出参数:  证书主题项值 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 查找证书的主题内容。
 */
int getCertSubject(OUT NSString * * str_cert_theme, IN const NSString * str_cert_id);


/*
 功能名称:  证书序列号查看
 函数名称:  getCertSerialNumber
 输入参数:  证书唯一标识 类型 string
 输出参数:  获取证书序列号 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 查找证书的序列号.
 */
int getCertSerialNumber(OUT NSString * * str_cert_serial_number, IN const NSString * str_cert_id);

/*
 功能名称:  证书详情查看
 函数名称:  getCertAttribute
 输入参数:  证书唯一标识 类型 string
 输出参数: 证书属性 类型 certInfo
 返回值:   成功：0
 失败：错误码
 功能描述: 解析出证书的所有属性信息
 */
int getCertAttribute(OUT certInfo * * ptr_cert_info, IN const NSString * str_cert_id);


/*
 功能名称:  证书获取
 函数名称:  getCertBuf
 输入参数:  证书唯一标识 类型 string
 输出参数: 获取证书字符串(base64编码) 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 获取证书结构base64编码后的字符串的值
 */
int getCertBuf(OUT NSString * * str_cert, IN const NSString * str_cert_id);


/*
 功能名称:  数据签名
 函数名称:  signMessage
 输入参数:  签名原文 类型 string
            证书唯一标识 类型 string
            签名HASH算法 类型 string (支持sha1、sm3)
            签名数据格式 类型 int (0表示裸签名,1表示P7 attach,2表示P7 detach)
 输出参数: 签名结果(base64编码) 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 使用证书对需要进行签名的数据进行签名。
 */
int signMessage(OUT NSString * * str_sign_out, IN const NSString * str_sign_in, IN const NSString * str_cert_id, IN const NSString * str_hash_alg, IN int i_sign_form);


/*
 功能名称:  签名验证
 函数名称:  verifyMessage
 输入参数:  签名原文 类型 string
            签名结果 类型 string
            签名HASH算法 类型 string (支持sha1、sm3)
            证书唯一标识 类型 string
            签名数据格式 类型 int (0表示裸签名,1表示P7 attach,2表示P7 detach)
 输出参数: 
 返回值:   成功：0
 失败：错误码
 功能描述: 使用证书对签名结果进行验证
 */
int verifyMessage(IN const NSString * str_sign_in, IN const NSString * str_sign_out, IN const NSString * str_cert_id, IN const NSString * str_hash_alg, IN int i_sign_form);


/*
 功能名称:  数据加密
 函数名称:  encryptMessage
 输入参数:  加密原文 类型 string 
           加密算法 类型 string 
           证书唯一标识 类型 string
 输出参数:  密文(base64编码) 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 使用证书对消息或者文件进行加密
 */
int encryptMessage(OUT NSString * * str_msg_out, IN const NSString * str_msg_in, IN const NSString * str_encryt_alg, IN const NSString * str_cert_id);


/*
 功能名称:  数据解密
 函数名称:  decryptMessage
 输入参数:  密文 类型 string
            加密算法 类型 string
            证书唯一标识 类型 string
            PIN码 类型 string (使用硬证书需要本参数)
 输出参数:  原文 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 使用证书私钥对密文进行解密
 */
int decryptMessage(OUT NSString * * str_msg_out, IN const NSString * str_msg_in, IN const NSString * str_encryt_alg, IN const NSString * str_cert_id);


/*
 功能名称:  枚举KEY
 函数名称:  enumKey
 输入参数:  设备名称 类型 string (默认为0;0表示所有设备类 型;1表示双接口KEY;2表示蓝牙KEY;)
 输出参数:  设备标识,计数从0开始 类型 string[]
 返回值:   成功：0
 失败：错误码
 功能描述: 枚举终端上接入的硬件证书存储设备。
 */
int enumKey( OUT NSMutableArray * * str_dev_id);


/*
 功能名称:  产生证书请求
 函数名称:  genCSR
 输入参数:  设备名称 类型 string
            姓名 类型 string (CN) 
            邮件 类型 string (Email)
            部门名称 类型 string (OU)
            单位名称 类型 string (O)
            密钥长度 (RSA:1024或2048;SM2:256)
            密钥类型 类型 string (RSA或SM2)
            介质类型 类型 string (1表示文件/软证书,2表示硬件证书)
 输出参数:  证书请求(base64编码) 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 在存储介质中产生密钥,返回公钥进行证书请求产生
 */
int genCSR( OUT NSString * * str_cert_req, IN const NSString * str_dev_name, IN const NSString * str_name, IN const NSString * str_email, IN const NSString * str_department, IN const NSString * str_unit, IN int i_prikey_len, IN const NSString * str_prikey_type);


/*
 功能名称:  产生证书请求通过原有密钥对
 函数名称:  genCSRWithCertID
 输入参数:  设备名称 类型 string
 姓名 类型 string (CN)
 邮件 类型 string (Email)
 部门名称 类型 string (OU)
 单位名称 类型 string (O)
 介质类型 类型 string (1表示文件/软证书,2表示硬件证书)
 证书唯一标识 类型 string
 输出参数:  证书请求(base64编码) 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 在存储介质中产生密钥,返回公钥进行证书请求产生
 */
int genCSRWithCertID( OUT NSString * * str_cert_req, IN const NSString * str_dev_name, IN const NSString * str_name, IN const NSString * str_email, IN const NSString * str_department, IN const NSString * str_unit, IN const NSString * str_cert_id);


/*
 功能名称:  证书导入
 函数名称:  importCert
 输入参数:  设备名称 类型 string
            证书字符串编码(base64格式) 类型 string
 输出参数:  
 返回值:   成功：0
 失败：错误码
 功能描述: 将CA产生的公钥证书导入存储介质与密钥对匹配保存
 */
int importCert(IN const NSString * str_dev_name, IN const NSString * str_cert);

/*
 功能名称:  PIN码校验
 函数名称:  verifyPIN
 输入参数:  设备名称 类型 string 
            输入口令 类型 string 
            重试次数 类型 int
 输出参数:
 返回值:   成功：0
 失败：错误码
 功能描述: 用户输入保护口令,调用存储介质的校验代码进行 验证,返回结果
 */
int verifyPIN(IN const NSString * str_dev_name, IN const NSString * str_pwd, IN int i_retry_times);


/*
 功能名称:  PIN码修改
 函数名称:  changePIN
 输入参数:  设备名称 类型 string 
            输入原口令 类型 string 
            输入新口令 类型 string
 输出参数:
 返回值:   成功：0
 失败：错误码
 功能描述: 用户输入原保护口令、新保护口令,改变证书的保护口令
 */
int changePIN(IN const NSString * str_dev_name, IN const NSString * str_pwd_ori, IN const NSString * str_pwd_new);


/*
 功能名称:  Key状态检测
 函数名称:  isRemovableDevice
 输入参数:  设备名称
 输出参数:  Key状态 类型 string (已插入或未插入等由Key厂 商提供)
 返回值:   成功：0
 失败：错误码
 功能描述: 检查KEY的状态是否插入
 */
int isRemovableDevice(OUT NSString * * str_dev_type, IN const NSString * str_dev_name);

/*
 功能名称:  解锁密码
 函数名称:  InitPIN
 输入参数:  用户密码 管理员密码
 输出参数:  无
 返回值:   成功：0
 失败：错误码
 功能描述: 通过管理员口令解锁用户口令
 */
int InitPIN(IN const NSString * str_pin_so ,IN const NSString * str_pin_usr);

/*
 功能名称:  修改密码
 函数名称:  SetPIN
 输入参数:  原密码 新密码 用户类型 0 管理员 其他 用户
 输出参数:  无
 返回值:   成功：0
 失败：错误码
 功能描述: 修改管理员或者用户密码
 */
int SetPIN(IN const NSString * str_pwd_ori, IN const NSString * str_pwd_new, IN unsigned int i_usr_type);

/*
 功能名称:  删除证书
 函数名称:  deleteCertBySerialNumber
 输入参数:  证书序列号
 输出参数:  无
 返回值:   成功：0
 失败：错误码
 功能描述: 通过序列号删除证书
 */
int deleteCertBySerialNumber(IN const NSString * str_cert_serial_number);


/*
 功能名称:  删除证书
 函数名称:  deleteCertByNickname
 输入参数:  证书友好名称
 输出参数:  无
 返回值:   成功：0
 失败：错误码
 功能描述: 通过友好名称删除证书
 */
int deleteCertByNickname(IN const NSString * str_cert_nickname);


/*
 功能名称:  证书nickname查看
 函数名称:  getCertSerialNumber
 输入参数:  证书唯一标识 类型 string
 输出参数:  获取证书序列号 类型 string
 返回值:   成功：0
 失败：错误码
 功能描述: 查找证书的序列号.
 */
int getCertNickName(OUT NSString * * str_cert_nickname, IN const NSString * str_cert_id);


/*
 功能名称:  设置LICENSE
 函数名称:  setLicense
 输入参数:  license名称 char *
 license值 char *
 输出参数:
 返回值:   -1:license 不成功  1:license 测试license 0:正式license
 功能描述: 设置LICENSE
 */
int setLicense(NSString * str_license_name, NSString * str_license_value);


#endif
