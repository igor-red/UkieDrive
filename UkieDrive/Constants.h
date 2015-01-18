//
//  Constants.h
//  UkieDrive
//
//  Created by Admin on 1/17/15.
//  Copyright (c) 2015 Igor Zhariy. All rights reserved.
//


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define _mainViewController [[MainViewController alloc] init]
#define _bounds [[UIScreen mainScreen] bounds]

// Macro for defining iPhones
#define _iPhone5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define _iPhone4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)
#define _iPhone6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON)
#define _iPhone6Plus (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON)


#ifndef UkieDrive_Constants_h
#define UkieDrive_Constants_h


#endif
