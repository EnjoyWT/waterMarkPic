//
//  WaterPicWithWord.m
//  mds
//
//  Created by mds on 2018/11/8.
//  Copyright © 2018年 mds. All rights reserved.
//

#import "WaterPicWithWord.h"
#define WATER_IMG_KEY @"water_image"
#define WATER_TEXT_KEY @"water_text"
#define WATER_FONT_SIZE_KEY @"font_size"
#define WATER_FONT_COLOR_KEY @"font_color"

@implementation WaterPicWithWord


+ (UIImage *)waterMarkImage:(NSDictionary *)webDic{
    
    if(webDic==nil){
        return nil;
    }
    NSDictionary *dic = [self parseParmas:webDic];
    
    if(dic==nil){
        return nil;
    }
    
    int fontSize = [[dic objectForKey:WATER_FONT_SIZE_KEY] intValue];
    UIColor *fontColor = [self colorWithHexString:[dic objectForKey:WATER_FONT_COLOR_KEY] alpha:1.0];
    float width = [UIApplication  sharedApplication].keyWindow.frame.size.width;
    float margin = 5.0;
    float maxWidth =width-28.0;
    NSString *textStr = [self handelWithTextArray:[dic objectForKey:WATER_TEXT_KEY] maxWidth:maxWidth fontSize:fontSize];
    UIImage *imge =  [self watermarkImage:[dic objectForKey:WATER_IMG_KEY] withName:textStr margin:margin fontSize:fontSize fontColor:fontColor];
    
    
    return imge;
    
}

+ (NSDictionary *)parseParmas:(NSDictionary *)dic{
    
    //图片对象, 文字, 字体颜色, 字体大小,间距,
    
    NSArray *keys = [dic allKeys];
    if(![keys containsObject:WATER_IMG_KEY]){
        return nil;
    }
    NSMutableDictionary *mutlDic = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    [mutlDic setObject:[dic objectForKey:WATER_IMG_KEY] forKey:WATER_IMG_KEY];
    
    if([keys containsObject:WATER_TEXT_KEY]){
   
        [mutlDic setObject:[dic objectForKey:WATER_TEXT_KEY] forKey:WATER_TEXT_KEY];
    }else{
         [mutlDic setObject:@"" forKey:WATER_TEXT_KEY];
    }
    //
    if([keys containsObject:WATER_FONT_COLOR_KEY]){
        [mutlDic setObject:[dic objectForKey:WATER_FONT_COLOR_KEY] forKey:WATER_FONT_COLOR_KEY];
    }else{
        [mutlDic setObject:@"#FFFFFF" forKey:WATER_FONT_COLOR_KEY];
    }
    
    if([keys containsObject:WATER_FONT_SIZE_KEY]){
        [mutlDic setObject:[dic objectForKey:WATER_FONT_SIZE_KEY] forKey:WATER_FONT_SIZE_KEY];
    }else{

        UIFont *newFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        UIFontDescriptor *ctfFont = newFont.fontDescriptor;
        NSNumber *fontString = [ctfFont objectForKey:@"NSFontSizeAttribute"];
        [mutlDic setObject:fontString forKey:WATER_FONT_SIZE_KEY];
    }
    
    
    return mutlDic;
}
+(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name margin:(float)margin fontSize:(float)fontSize fontColor:(UIColor *)fontColor
{
    
    //处理字符串
    NSString* mark = name;
    int w = img.size.width;
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0,0 , w, h)];
    NSDictionary *attr = @{
                           
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize],  //设置字体
                           NSForegroundColorAttributeName : fontColor   //设置字体颜色
                           
                           };
    
    NSMutableAttributedString * attr_str =[[NSMutableAttributedString alloc]initWithString:name attributes:attr];
    //文字：字符串的宽、高
    CGFloat str_w = attr_str.size.width;
    CGFloat str_h = attr_str.size.height;
    
    int postsion = 2;
    CGRect textRect = CGRectMake(margin, h-str_h-margin/4, w, h);
    
    switch (postsion) {
        case 0://左上
        textRect = CGRectMake(margin, margin, w, h);
        break;
        case 1://右上
        textRect = CGRectMake(w-str_w+margin, margin, w, h);
        break;
        case 2://左下
        textRect = CGRectMake(margin, h-str_h-margin/4, w, h);
        break;
        case 3://右下
        textRect = CGRectMake(w-str_w-margin, h-str_h-margin, w, h);
        break;
        default:
        break;
    }
    
    [mark drawInRect:textRect withAttributes:attr];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
}

+(NSString *)handelWithTextArray:(NSArray*)textArray maxWidth:(int)width fontSize:(int)size{
    
    NSString *resText = @"";
    for (NSString *itemText in textArray) {
        if([resText isEqualToString:@""]){
            resText = [NSString stringWithFormat:@"\n%@",[self limitTextWight:itemText maxWidth:width fontSize:(int)size]];
        }else{
            resText = [NSString stringWithFormat:@"%@\n%@",resText,[self limitTextWight:itemText maxWidth:width fontSize:(int)size]];
        }
        
    }
    return resText;
}

+ (NSString *)limitTextWight:(NSString *)itemText maxWidth:(int)width fontSize:(int)size{
    
    float textLong = [self obtainAttributeSizeWithText:itemText fontSize:size].width;
    
    if(textLong<=width){
        return itemText;
    }
    
    NSString *resText =@"";
    NSString *ddText =@"";
    NSString *tempOText =itemText;
    
    while (textLong>width) {
        
        resText = [itemText substringWithRange:NSMakeRange(0, tempOText.length-1)];
        
        ddText = [NSString stringWithFormat:@"%@%@",[tempOText substringWithRange:NSMakeRange(tempOText.length-1, 1)],ddText];
        tempOText = resText;
        textLong = [self obtainAttributeSizeWithText:resText fontSize:size].width;
    }
    
    //直接通过字符长度直接截取,字段
    int maxleng = (int)resText.length;
    NSString *tempRight = @"";
    while (ddText.length>maxleng) {
        NSString *tempStr = [ddText substringWithRange:NSMakeRange(0, maxleng)];
        ddText = [ddText substringWithRange:NSMakeRange(maxleng, ddText.length-maxleng)];
        
        if([tempRight isEqualToString:@""]){
            tempRight = tempStr;
        }else{
            tempRight = [NSString stringWithFormat:@"%@\n%@",tempRight,tempStr];
            
        }
        
    }
    
    if(ddText.length>0){
        tempRight = [NSString stringWithFormat:@"%@\n%@",tempRight,ddText];
    }
    if(![tempRight isEqualToString:@""]){
        resText = [NSString stringWithFormat:@"%@\n%@",resText,tempRight];
    }
    
    
    return resText;
}

+ (int)coutOfUnit:(NSString *)textString{
    NSRegularExpression*tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]"options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:textString
                                 
                                                                       options:NSMatchingReportProgress
                                 
                                                                         range:NSMakeRange(0, textString.length)];
    
    //英文字条件
    
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:textString options:NSMatchingReportProgress range:NSMakeRange(0, textString.length)];
    
    //中文条件
    
    NSRegularExpression *tChineseRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]"options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger tChineseMatchCount = [tChineseRegularExpression numberOfMatchesInString:textString options:NSMatchingReportProgress range:NSMakeRange(0, textString.length)];
    
    NSLog(@"数字的个数=%ld 字母的个数=%ld汉字的个数=%ld",tNumMatchCount,tLetterMatchCount,tChineseMatchCount);
    
    return (int)(tNumMatchCount +tLetterMatchCount+tChineseMatchCount);
    
}
+(CGSize) obtainAttributeSizeWithText:(NSString *)text fontSize:(int)fontSize
{
    CGSize size=[text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >=7.0) {
        size=[text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    }else{
        NSAttributedString *attributeSting = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
        size = [attributeSting size];
    }
    return size;
}


+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}

@end
