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

@interface FirstViewController ()

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

- (IBAction)weiXinPay:(id)sender {
/*
    NSString *postUrl = @"INPUT YOUR URL HERE";
    
    NSDictionary *parameters = @{@"PARAMETERS NAME 1": @"PARAMETERS VALUE 1",
                                 @"PARAMETERS NAME 2": @"PARAMETERS VALUE 2"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //方法一：
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //注意：默认的Response为json数据
    //    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//使用这个将得到的是NSData
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    
    //注意：此行不加也可以
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain; charset=utf-8"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    
    //SEND YOUR REQUEST
    [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString *str = [responseObject objectForKey:@"KEY 1"];
        NSArray *arr = [responseObject objectForKey:@"KEY 2"];
        NSDictionary *dic = [responseObject objectForKey:@"KEY 3"];
        
        //...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
 
     */

    NSLog(@"5555");
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp= @"1397527777".intValue ;
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
// 
//    NSLog(@"weiXinPay:(id)sender ");
//    [self performSegueWithIdentifier:@"AA" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue!");
    UIViewController *vcTemp = (UIViewController*)segue.destinationViewController;
    if ([vcTemp respondsToSelector:@selector(setStrX:)]) {
        [vcTemp setValue:@"123abcxxx" forKey:@"strX"];
    }
}

//-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    NSLog(@"performSegueWithIdentifier!");
//    [super performSegueWithIdentifier:identifier sender:self];
//}

@end
