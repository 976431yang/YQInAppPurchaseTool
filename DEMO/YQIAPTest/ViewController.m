//
//  ViewController.m
//  YQIAPTest
//
//  Created by problemchild on 16/8/25.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import "ViewController.h"

#import "YQInAppPurchaseTool.h"

#import "SVProgressHUD.h"

@interface ViewController ()<YQInAppPurchaseToolDelegate,
                             UITableViewDataSource,
                             UITableViewDelegate>

@property (nonatomic,strong) UITableView    *tabV;

@property (nonatomic,strong) NSMutableArray *productArray;

@end

@implementation ViewController

-(NSMutableArray *)productArray{
    if(!_productArray){
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    //获取单例
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    
    //设置代理
    IAPTool.delegate = self;
    
    //购买后，向苹果服务器验证一下购买结果。默认为YES。不建议关闭
    //IAPTool.CheckAfterPay = NO;
    
    [SVProgressHUD showWithStatus:@"向苹果询问哪些商品能够购买"];
    
    //向苹果询问哪些商品能够购买
    [IAPTool requestProductsWithProductArray:@[@"com.problenchild.YQIAPTest.product1",
                                               @"com.problenchild.YQIAPTest.product2",
                                               @"com.problenchild.YQIAPTest.product3"]];
}

#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
-(void)IAPToolGotProducts:(NSMutableArray *)products {
    NSLog(@"GotProducts:%@",products);
//    for (SKProduct *product in products){
//        NSLog(@"localizedDescription:%@\nlocalizedTitle:%@\nprice:%@\npriceLocale:%@\nproductID:%@",
//              product.localizedDescription,
//              product.localizedTitle,
//              product.price,
//              product.priceLocale,
//              product.productIdentifier);
//        NSLog(@"--------------------------");
//    }
    self.productArray = products;
    
    [self.tabV reloadData];
    
    [SVProgressHUD showSuccessWithStatus:@"成功获取到可购买的商品"];
}
//支付失败/取消
-(void)IAPToolCanceldWithProductID:(NSString *)productID {
    NSLog(@"canceld:%@",productID);
    [SVProgressHUD showInfoWithStatus:@"购买失败"];
}
//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
-(void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
    
    [SVProgressHUD showWithStatus:@"购买成功，正在验证购买"];
}
//商品被重复验证了
-(void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    NSLog(@"CheckRedundant:%@",productID);
    
    [SVProgressHUD showInfoWithStatus:@"重复验证了"];
}
//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
-(void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                            andInfo:(NSDictionary *)infoDic {
    NSLog(@"BoughtSuccessed:%@",productID);
    NSLog(@"successedInfo:%@",infoDic);
    
    [SVProgressHUD showSuccessWithStatus:@"购买成功！(相关信息已打印)"];
}
//商品购买成功了，但向苹果服务器验证失败了
//2种可能：
//1，设备越狱了，使用了插件，在虚假购买。
//2，验证的时候网络突然中断了。（一般极少出现，因为购买的时候是需要网络的）
-(void)IAPToolCheckFailedWithProductID:(NSString *)productID
                                 andInfo:(NSData *)infoData {
    NSLog(@"CheckFailed:%@",productID);
    
    [SVProgressHUD showErrorWithStatus:@"验证失败了"];
}
//恢复了已购买的商品（仅限永久有效商品）
-(void)IAPToolRestoredProductID:(NSString *)productID {
    NSLog(@"Restored:%@",productID);
    
    [SVProgressHUD showSuccessWithStatus:@"成功恢复了商品（已打印）"];
}
//内购系统错误了
-(void)IAPToolSysWrong {
    NSLog(@"SysWrong");
    [SVProgressHUD showErrorWithStatus:@"内购系统出错"];
}


#pragma mark --------Functions
//初始化界面显示
-(void)setupViews{
    self.tabV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tabV.delegate = self;
    self.tabV.dataSource = self;
    
    [self.view addSubview:self.tabV];
    
    //注册重用单元格
    [self.tabV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
    
    self.navigationItem.rightBarButtonItem =({
        UIBarButtonItem *BTN = [[UIBarButtonItem alloc]initWithTitle:@"说明"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(ShowInfo)];
        BTN;
    });
    
    self.navigationItem.leftBarButtonItem =({
        UIBarButtonItem *BTN = [[UIBarButtonItem alloc]initWithTitle:@"恢复已购买商品"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(restoreProduct)];
        BTN;
    });
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

//显示说明
-(void)ShowInfo{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle:@"说明！"
                   message:@"请使用真机进行测试\n\n请使用以下账号进行购买：\n账号：2966435424@qq.com\n密码：Mima123456"
                   delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles: nil];
    [alertDialog show];
}

//恢复已购买的商品
-(void)restoreProduct{
    
    [SVProgressHUD showWithStatus:@"正在恢复商品"];
    
    //直接调用
    [[YQInAppPurchaseTool defaultTool]restorePurchase];
}

//购买商品
-(void)BuyProduct:(SKProduct *)product{
    
    [SVProgressHUD showWithStatus:@"正在购买商品"];
    
    [[YQInAppPurchaseTool defaultTool]buyProduct:product.productIdentifier];
}

#pragma mark --------UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.productArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动从重用队列中取得名称是MyCell的注册对象,如果没有，就会生成一个
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    //清除cell上的原有view
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    SKProduct *product = self.productArray[indexPath.section];
    
    //cell的设置
    cell.textLabel.text = [NSString stringWithFormat:@"本地化商品描述:%@\n\n本地化商品标题:%@\n\n价格:%@\n\n商品ID:%@",
                                         product.localizedDescription,
                                         product.localizedTitle,
                                         product.price,
                                         product.productIdentifier];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tabV deselectRowAtIndexPath:indexPath animated:YES];
    
    [self BuyProduct:self.productArray[indexPath.section]];
}

@end
