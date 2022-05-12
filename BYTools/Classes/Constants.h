//
//  Constants.h
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/4/28.
//

#ifndef Constants_h
#define Constants_h

#ifdef DEBUG
#define kLog(fmt, ...) NSLog((@"---%d行---" fmt), __LINE__, ##__VA_ARGS__);
#else
#define kLog(...);
#endif

#define BYStrIsEmpty(str) ([str isKindOfClass:[NSNull class]] || [str length] < 1 ? YES : NO || [str isEqualToString:@"(null)"] || [str isEqualToString:@"null"])

#endif /* Constants_h */
