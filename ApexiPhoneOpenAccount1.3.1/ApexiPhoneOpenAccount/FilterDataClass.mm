//
//  FilterDataClass.m
//  ApexiPhoneOpenAccount
//
//  Created by mac  on 14-5-28.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "FilterDataClass.h"
#include <string>
#import "Data_Structure.h"
using namespace std;

FilterDataClass::FilterDataClass(){
    filterResultArray = [NSMutableArray array];
    InitCharacterDict();
}

FilterDataClass::~FilterDataClass() {
    m_mapCharacter.clear();
}

void FilterDataClass:: FilterRoster (const std::string& m_sFilter, int nMaxCount)
{
    [filterResultArray removeAllObjects];
    
	if (m_sFilter != "")
	{
		AxToLowerCase (const_cast<string&>(m_sFilter));
		
		for (int i = 0;i<filterArray.count ; i++)
		{
            if([[filterArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]){
                NSDictionary * filDic = [filterArray objectAtIndex:i];
                string filterSourceString = [[filDic objectForKey:UPNOTE] UTF8String];
//                NSLog(@"fildic ,source=%@,%s,%s",filDic,filterSourceString.c_str(),m_sFilter.c_str());
                if (filterSourceString.find (m_sFilter) != std::string::npos ||
                    GetFullPronounce(filterSourceString, "").find (m_sFilter) != std::string::npos)
                {
//                    NSLog(@"fildicsource=%s",GetFullPronounce(filterSourceString, "").c_str());
                    [filterResultArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:filterSourceString.c_str()],UPNOTE,nil]];
                }
            }
		}
	}
}

void FilterDataClass:: InitCharacterDict ()
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cnCharacter" ofType:@"txt"];
    
	if ([fm fileExistsAtPath: filePath] == YES)
	{
		NSData *fileData = [fm contentsAtPath: filePath];
		if (fileData != nil)
		{
			NSString *nsContent = [[NSString alloc] initWithData: fileData encoding: NSUTF8StringEncoding];
			std::string sContent = [nsContent UTF8String];
			
			std::string sCharacter;
			std::string sPronun;
			std::string sLine;
			
			while (true)
			{
				int nEndPos = sContent.find ("\n");
				if (nEndPos == std::string::npos)
				{
					break;
				}
				
				sLine = sContent.substr (0, nEndPos - 1);
				sContent = sContent.substr (nEndPos + 1, sContent.length () - nEndPos - 1);
				
				int nSpacePos = sLine.find (" ");
				if (nSpacePos != std::string::npos)
				{
					sCharacter = sLine.substr (0, nSpacePos);
					sLine = sLine.substr (nSpacePos + 1, sLine.length () - nSpacePos - 1);
					sPronun = "";
					
					while (nSpacePos != std::string::npos)
					{
						nSpacePos = sLine.find (" ");
						if (nSpacePos != std::string::npos)
						{
							sPronun += sLine.substr (0, nSpacePos) + ";";
							sLine = sLine.substr (nSpacePos + 1, sLine.length () - nSpacePos - 1);
						}
					}
					
					if (sLine != "")
					{
						sPronun += sLine;
					}
					
					m_mapCharacter[sCharacter] = sPronun;
				}
			}
		}
	}
}

std::string FilterDataClass:: GetFullPronounce (std::string sOriginal, std::string sTempOut)
{
//    NSString *sttt=[NSString stringWithFormat:@"%s",sOriginal.c_str()];
    
	std::string sRs = sTempOut;
	sOriginal = AxToLowerCase (sOriginal);
 	int nLength = sOriginal.length ();
	
	for (int i = 0; i < nLength; i ++)
	{
		if (sOriginal[i] & 0x80 && i < nLength - 2)
		{
			string sCharacter = sOriginal.substr (i, 3);
			if (m_mapCharacter[sCharacter] != "")
			{
				string sPronun = m_mapCharacter[sCharacter];
				
				int nEndPos = sPronun.find (";");
				if (nEndPos != std::string::npos)
				{
					string sTRs = sRs;
					sRs = "";
					
					string sSubOrgString = sOriginal.substr (i + 3, nLength - i - 3);
					
					do
					{
						string sSubPronun = sPronun.substr (0, nEndPos);
						sRs += GetFullPronounce (sSubOrgString, sTRs + sSubPronun) + ";";
						sPronun = sPronun.substr (nEndPos + 1, sPronun.length () - nEndPos - 1);
						
						nEndPos = sPronun.find (";");
						if (nEndPos == std::string::npos)
						{
							sRs += GetFullPronounce (sSubOrgString, sTRs + sPronun) + ";";
						}
						
					}
                    while (nEndPos != std::string::npos);
					
					break;
				}
				else
				{
					sRs += sPronun;
				}
			}
			else
			{
				sRs += sCharacter;
			}
			
			i += 2;
		}
		else
		{
			sRs += sOriginal[i];
		}
	}
    
	return sRs;
}

std::string FilterDataClass:: AxToLowerCase ( std::string& sText)
{
	int nLength = sText.length ();
	for (int i = 0; i < nLength; i ++)
	{
		if (sText[i] >= 'A' && sText[i] <= 'Z')
		{
			sText[i] += ('a' - 'A');
		}
	}
	
	return sText;
}

//@end
