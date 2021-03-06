//
//  SqlDB.h
//  EMT_TEST
//
//  Created by R&D on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "sqlite3.h"

#define DATA_MAX_LEN 64
#define MAX_BUFFER_LEN 1024

typedef struct _SUserInfo{
    int ID;
    char version_id[DATA_MAX_LEN];
    char build_id[DATA_MAX_LEN];
    char hardware_id[DATA_MAX_LEN];
    char password[DATA_MAX_LEN];
}SUserInfo;


typedef struct _DBInfo{
    int ID;
    char version_id[DATA_MAX_LEN];
    char build_id[DATA_MAX_LEN];
    char hardware_id[DATA_MAX_LEN];
    char password[DATA_MAX_LEN];
}SDBInfo;


int functionOpenDB(sqlite3 * * database);
int functionCloseDB(sqlite3 * database);



int functionCreateTableUserInfo(sqlite3 * database);
int functionDropTableUserInfo(sqlite3 * database);

int functionUserInfoInsert(sqlite3 * database,void * param);
int functionUserInfoDelete(sqlite3 * database,void * param);
int functionUserInfoUpdate(sqlite3 * database,void * param);
int functionUserInfoSelect(sqlite3 * database,void * param);


int functionCreateTableDBInfo(sqlite3 * database);
int functionDropTableDBInfo(sqlite3 * database);

int functionDBInfoInsert(sqlite3 * database,void * param);
int functionDBInfoDelete(sqlite3 * database,void * param);
int functionDBInfoUpdate(sqlite3 * database,void * param);
int functionDBInfoSelect(sqlite3 * database,void * param);



