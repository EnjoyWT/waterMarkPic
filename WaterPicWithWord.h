//
//  WaterPicWithWord.h
//  mds
//
//  Created by mds on 2018/11/8.
//  Copyright © 2018年 mds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WaterPicWithWord : NSObject
/*
 * 网络插件需要通过字典的形式传递照片对象,
 * 需要wen端提供文字文字参数以数据的形式提供,数组顺序为显示顺序(从上到下),
 * 默认左下角显示, 从上,
 * 默认字体大小为手机系统字体大小.
 * 默认字体颜色为白色.
 * 默认字体颜色标识方法为16进制表示方法.
 * water_image， water_text， font_size， font_color
 */
+ (UIImage *)waterMarkImage:(NSDictionary *)webDic;
@end
