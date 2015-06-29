//
//  framework.h
//  framework
//
//  Created by Walter on 7/17/12.
//  Copyright (c) 2012 信安珞珈科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INFOSEC_RV UInt32

#define INFOSEC_E_SUCCESS               0x00
#define INFOSEC_E_PARAMETER             0x01
#define INFOSEC_E_PIN                   0x02
#define INFOSEC_E_ALG                   0x05

#define INFOSEC_E_CERTIFICATE_PARSING   0x12
#define INFOSEC_E_FILE_NOT_FOUND        0x13
#define INFOSEC_E_INVALID_KEY           0x14
#define INFOSEC_E_SIGNATURE             0x15
#define INFOSEC_E_INTERNAL              0x99


typedef enum
{
    MY_CERT_SUBJECT = 1,
    MY_CERT_ISSUER,
    MY_CERT_NOTBEFORE,
    MY_CERT_NOTAFTER,
    MY_CERT_SERIALNUMBER,
    MY_CERT_ALG,
    MY_CERT_KEY_USAGE,
}eInfosecCertInfoType;

typedef enum 
{
    INFOSEC_HASH_ALG_SHA1 =1,
    INFOSEC_HASH_ALG_SM3,
}eInfosecHashAlg;

INFOSEC_RV infosec_init();

@protocol InfosecSecurity <NSObject>

- (INFOSEC_RV) createP10:(NSMutableData*)p10
                  WithDN:(NSString*)DN
               algorithm:(NSString*)alg
               keyLength:(UInt32)len
             keyStorePwd:(NSString*)pwd;

- (INFOSEC_RV) importCert:(NSString*)base64Cert
              keyStorePwd:(NSString*)pwd;

- (INFOSEC_RV) attachedSignData:(NSData*)data
                    keyStorePwd:(NSString*)pwd
                      signature:(NSMutableData*)signature;

- (INFOSEC_RV) detachedSignData:(NSData*)data
                    keyStorePwd:(NSString*)pwd
                      signature:(NSMutableData*)signature;

- (INFOSEC_RV) rawSignData:(NSData*)data
               keyStorePwd:(NSString*)pwd
                 signature:(NSMutableData*)signature;

- (INFOSEC_RV) encodeData:(NSData*)data
                 toBase64:(NSMutableData*)base64;

- (INFOSEC_RV) decodeBase64:(NSData*)base64
                     toData:(NSMutableData*)data;

- (INFOSEC_RV) getSignerCertInfo:(NSString**)info
                          ofType:(eInfosecCertInfoType)type;

- (INFOSEC_RV) hashData:(NSData*)data
                withAlg:(eInfosecHashAlg)alg
               toBase64:(NSMutableData*)base64;

- (INFOSEC_RV) changeOldPIN:(NSString*)oldPIN
                   toNewPIN:(NSString*)newPIN;

@end