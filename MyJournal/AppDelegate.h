//
//  AppDelegate.h
//  MyJounal
//
//  Created by 상현 이 on 12. 8. 30..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) ViewController *viewController;

@end
