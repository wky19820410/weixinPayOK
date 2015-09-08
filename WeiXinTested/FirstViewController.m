//
//  FirstViewController.m
//  WeiXinTested
//
//  Created by mobiusif on 15/8/24.
//  Copyright (c) 2015年 wky. All rights reserved.
//

#import "FirstViewController.h"
#import "WXApi.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Common.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface FirstViewController (){
    UIWebView *webView;
    JSContext *jsContext;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, 400)];
    
    webView.delegate = self;
    webView.backgroundColor = [UIColor colorWithRed:23/255.0 green:133/255.0 blue:144/255.0 alpha:1.0f];
    [self.view addSubview:webView];
}
- (IBAction)jsTest:(id)sender {
    NSLog(@"jsTest");
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
//    
//    //SEND YOUR REQUEST
//    [manager POST:REQUEST_PAY2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    NSString *path = [[NSBundlemainBundle] pathForResource:@"HtmlTest"ofType:@"html"];
    
    
    

    
    
    
    //webView载入一个本地的html数据，当然也可以从一个url载入webView
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:REQUEST_PAY2]]];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)awebView {
    
//    NSString *string = [awebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('field_2').value;" ];
//    
//    NSLog(@"string:%@", string);
//    
//    //这样就得到了field_2控件的value.
//    NSLog(@"webViewDidFinishLoad!!!");
//    NSString *lJs = @"document.documentElement.innerHTML";
//    [self executeJSFunction:lJs];
//    NSString *str1 = @"document.getElementById('topimage').src;";
//    [self executeJSFunction:str1];
    if (jsContext == nil) {
        // 1.
        jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        // 2. 关联打印异常
        jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
        };
        
        jsContext[@"fuc"] = ^(NSDictionary *param) {
            NSLog(@"fuc ok!!!!!!!");
            NSLog(@"param== %@",param);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertViewTest"
                                                            message:[NSString stringWithFormat:@"%@",param]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OtherBtn",nil];
            [alert show];
        };
        jsContext[@"xyz"] = ^() {
            NSLog(@"xyz");
        };
        // Mozilla/5.0 (iPhone; CPU iPhone OS 10_10 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12B411
//        id userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//        NSLog(@"%@", userAgent);
    }
}
- (IBAction)btnEventHtml5:(id)sender {
    NSLog(@"btnEventHtml5!!!!!");
    NSString *str = @"document.getElementById(\"test\").value=\"456789\"";
//    [jsContext evaluateScript:str];
    [self executeJSFunction:str];
}
//返回运行后js结果
- (void)executeJSFunction:(NSString *)jsCommand{
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:jsCommand];
    NSLog(@"result:%@",result);
}

- (IBAction)weiXinPay:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"not isWXAppInstalled");
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];

    //SEND YOUR REQUEST
    [manager POST:REQUEST_PAY parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        时间转时间戳的方法:
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        NSLog(@"timeSp:%@",timeSp); //时间戳的值
        
        PayReq *req = [[PayReq alloc] init];
        req.openID              = APP_ID;                    //app id
        req.partnerId           = [responseObject objectForKey:@"mch_id"];      //微信分配的商户账号，eg：1000102344
        req.prepayId            = [responseObject objectForKey:@"prepay_id"];       //预付费单号
        req.nonceStr            = [self genRandomString];                           //本地产生的随机数
        req.timeStamp           = timeSp.intValue;                                  //时间戳从服务器获取，临时从本地获取
        req.package             = @"Sign=WXPay";                                     //固定的格式

        //第二次签名参数列表，后续用于md5的签名
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: req.openID  forKey:@"appid"];            //官方的api和sdk不一直，注意这个参数的设置，其它目前没有发现问题。20150827
        [signParams setObject: req.partnerId  forKey:@"partnerid"];
        [signParams setObject: req.prepayId    forKey:@"prepayid"];
        [signParams setObject: req.nonceStr   forKey:@"noncestr"];
        [signParams setObject: timeSp   forKey:@"timestamp"];
        [signParams setObject: req.package      forKey:@"package"];
        
        req.sign                = [self createMd5Sign:signParams key:APP_KEY];
        
        //日志输出
        NSLog(@"req.openID=%@\n  req.partnerId=%@\n   req.prepayId=%@\n   req.nonceStr=%@\n      req.timeStamp=%ld\n      req.package=%@  \n   req.sign=%@",
              req.openID,      req.partnerId,        req.prepayId,        req.nonceStr,          (long)req.timeStamp,    req.package,          req.sign );
        [WXApi sendReq:req];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


//创建package签名(发送到微信客户端) 官方sdk算法
- (NSString*) createMd5Sign:(NSMutableDictionary*)dict  key:(NSString *)strKey
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSLog(@"sortedArray ==%@",sortedArray);
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", strKey];
    //得到MD5 sign签名
    NSString *md5Sign =[[self class] md5:contentString];
    
    //输出Debug Info
    NSLog(@"MD5签名字符串：\n%@\n\n",contentString);
    
    return md5Sign;
}

//md5 encode 官方sdk算法
+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}
//产生随机数的函数，微信客户端的要求少于32字符
- (NSString *)genRandomString{
#define NUMBER_OF_CHARS 30
    char data[NUMBER_OF_CHARS];
    for (int x = 0 ; x < NUMBER_OF_CHARS ; )
        data[x++] = (char)('A' + (arc4random_uniform(26)));
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

@end
