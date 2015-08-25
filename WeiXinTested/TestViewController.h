//
//  TestViewController.h
//  WeiXinTested
//
//  Created by mobiusif on 15/8/25.
//  Copyright (c) 2015年 wky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (nonatomic,strong) NSString *strX;
@property (weak, nonatomic) IBOutlet UILabel *labShwo;

- (IBAction)btnTest:(id)sender;


@end
