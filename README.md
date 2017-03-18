# YQInAppPurchaseTool
#### 微博：畸形滴小男孩

### iOS苹果内购集成工具


#### 使用方法：
##### 1把文件拖到XCodeg工程中，并开启工程的IAP：
 ![image](https://github.com/976431yang/YQInAppPurchaseTool/blob/master/DEMO/ScreenShot/ScrrenShot01.png)

##### 2引入头文件
```Objective-C
#import "YQInAppPurchaseTool.h"
```
##### 3添加代理
```Objective-C
<YQInAppPurchaseToolDelegate>
```
##### 4遵循、实现代理
```Objective-C
//-----------获取单例
YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
//-----------设置代理
IAPTool.delegate = self;

//-----------实现代理
//IAP工具已获得可购买的商品
-(void)IAPToolGotProducts:(NSMutableArray *)products {
    NSLog(@"GotProducts:%@",products);
}
//支付失败/取消
-(void)IAPToolCanceldWithProductID:(NSString *)productID {
    NSLog(@"canceld:%@",productID);
}
//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
-(void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
}
//商品被重复验证了
-(void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    NSLog(@"CheckRedundant:%@",productID);
}
//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
-(void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                            andInfo:(NSDictionary *)infoDic {
    NSLog(@"BoughtSuccessed:%@",productID);
    NSLog(@"successedInfo:%@",infoDic);
}
//商品购买成功了，但向苹果服务器验证失败了
//2种可能：
//1，设备越狱了，使用了插件，在虚假购买。
//2，验证的时候网络突然中断了。（一般极少出现，因为购买的时候是需要网络的）
-(void)IAPToolCheckFailedWithProductID:(NSString *)productID
                                 andInfo:(NSData *)infoData {
    NSLog(@"CheckFailed:%@",productID);
}
//恢复了已购买的商品（仅限永久有效商品）
-(void)IAPToolRestoredProductID:(NSString *)productID {
    NSLog(@"Restored:%@",productID);
}
//内购系统错误了
-(void)IAPToolSysWrong {
    NSLog(@"SysWrong");
}
```
##### 5使用
```Objective-C
//向苹果询问哪些商品能够购买
[IAPTool requestProductsWithProductArray:@[@"productID1",
                                           @"productID2",
                                           @"productID3"]];
//请求购买商品
[[YQInAppPurchaseTool defaultTool]buyProduct:product.productIdentifier];  
//请求恢复商品(永久性商品)(也可直接再次购买，系统会提示不用扣费)
[[YQInAppPurchaseTool defaultTool]restorePurchase];
```

##### 6购买流程
1.向苹果询问哪些商品可以购买<br> 
2.请求购买商品<br> 
3.代理会自动响应购买中的各个状态<br> 
---3.1.购买成功，开始向苹果服务器验证购买凭证（可设置跳过）<br> 
------3.1.1.验证成功(购买过程结束)<br> 
------3.1.2.验证失败(可能用户越狱了在虚假购买)<br> 
---3.2.购买失败<br> 

-更详细使用方法可下载DEMO工程查看

