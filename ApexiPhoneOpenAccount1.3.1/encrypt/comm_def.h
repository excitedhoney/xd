//
//  comm_def.h
//  TestOnly4NSS_NSPR
//
//  Created by YXCD on 13-8-30.
//  Copyright (c) 2013年 YXCD. All rights reserved.
//

#ifndef TestOnly4NSS_NSPR_comm_def_h
#define TestOnly4NSS_NSPR_comm_def_h

#ifndef __CK_C_INITIALIZE_ARGS_NSS

#define __CK_C_INITIALIZE_ARGS_NSS

#include "pkcs11.h"

#include "prprf.h"

typedef struct CK_C_INITIALIZE_ARGS_NSS {
    CK_CREATEMUTEX CreateMutex;
    CK_DESTROYMUTEX DestroyMutex;
    CK_LOCKMUTEX LockMutex;
    CK_UNLOCKMUTEX UnlockMutex;
    CK_FLAGS flags;
    /* The official PKCS #11 spec does not have a 'LibraryParameters' field, but
     * a reserved field. NSS needs a way to pass instance-specific information
     * to the library (like where to find its config files, etc). This
     * information is usually provided by the installer and passed uninterpreted
     * by NSS to the library, though NSS does know the specifics of the softoken
     * version of this parameter. Most compliant PKCS#11 modules expect this
     * parameter to be NULL, and will return CKR_ARGUMENTS_BAD from
     * C_Initialize if Library parameters is supplied. */
    CK_CHAR_PTR *LibraryParameters;
    /* This field is only present if the LibraryParameters is not NULL. It must
     * be NULL in all cases */
    CK_VOID_PTR pReserved;
} CK_C_INITIALIZE_ARGS_NSS;

#endif


#endif
