//
//  FilterDataClass.h
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-28.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>
#include <map>
using namespace std;

class FilterDataClass{
    
public:
	FilterDataClass ();
    
public:
	~FilterDataClass ();
    
    std::string GetFullPronounce (const std::string sOriginal,const std::string sTempOut);
    
    std::string AxToLowerCase (std::string& sText);
    
    void InitCharacterDict();
    
    void FilterRoster (const std::string& sFilter, int nMaxCount);
    
public:
    map<string, string>						m_mapCharacter;
    NSMutableArray *                        filterArray;
    NSMutableArray *                        filterResultArray;
};

//@interface FilterDataClass : NSObject{

//}

//@end
