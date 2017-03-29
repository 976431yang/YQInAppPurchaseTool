//
//  YQInAppPurchaseTool.h
//  YQStoreToolDemo
//
//  Created by problemchild on 16/8/24.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#pragma mark --------YQInAppPurchaseToolDelegate--内购代理
/**
 *  内购工具的代理
 */
@protocol YQInAppPurchaseToolDelegate <NSObject>

/**
 *  代理：系统错误
 */
-(void)IAPToolSysWrong;

/**
 *  代理：已刷新可购买商品
 *
 *  @param products 商品数组
 */
-(void)IAPToolGotProducts:(NSMutableArray *)products;

/**
 *  代理：购买成功
 *
 *  @param productID 购买成功的商品ID
 */
-(void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                            andInfo:(NSDictionary *)infoDic;;

/**
 *  代理：取消购买
 *
 *  @param productID 商品ID
 */
-(void)IAPToolCanceldWithProductID:(NSString *)productID;

/**
 *  代理：购买成功，开始验证购买
 *
 *  @param productID 商品ID
 */
-(void)IAPToolBeginCheckingdWithProductID:(NSString *)productID;

/**
 *  代理：重复验证
 *
 *  @param productID 商品ID
 */
-(void)IAPToolCheckRedundantWithProductID:(NSString *)productID;

/**
 *  代理：验证失败
 *
 *  @param productID 商品ID
 */
-(void)IAPToolCheckFailedWithProductID:(NSString *)productID
                                 andInfo:(NSData *)infoData;

/**
 *  恢复了已购买的商品（永久性商品）
 *
 *  @param productID 商品ID
 */
-(void)IAPToolRestoredProductID:(NSString *)productID;


@end

#pragma mark --------YQInAppPurchaseTool--内购工具
/**
 *  内购工具
 */
@interface YQInAppPurchaseTool : NSObject

typedef void(^BoolBlock)(BOOL successed,BOOL result);

typedef void(^DicBlock)(BOOL successed,NSDictionary *result);

/**
 *  代理
 */
@property(nonatomic,weak) id <YQInAppPurchaseToolDelegate> delegate;

/**
 *  购买完后是否在iOS端向服务器验证一次,默认为YES
 */
@property(nonatomic)BOOL CheckAfterPay;

/**
 *  单例
 *
 *  @return YQInAppPurchaseTool
 */
+(YQInAppPurchaseTool *)defaultTool;

/**
 *  询问苹果的服务器能够销售哪些商品
 *
 *  @param products 商品ID的数组
 */
- (void)requestProductsWithProductArray:(NSArray *)products;

/**
 *  用户决定购买商品
 *
 *  @param productID 商品ID
 */
- (void)buyProduct:(NSString *)productID;


/**
 *  恢复商品（仅限永久有效商品）
 */
- (void)restorePurchase;

@end
