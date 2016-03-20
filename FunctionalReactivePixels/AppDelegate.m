//
//  AppDelegate.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 19/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "AppDelegate.h"
#import "FRPGalleryViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) PXAPIHelper *apiHelper;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[FRPGalleryViewController alloc] init]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  NSString *consumerKey = @"DC2To2BS0ic1ChKDK15d44M42YHf9gbUJgdFoF0m";
  NSString *consumerSecret = @"i8WL4chWoZ4kw9fh3jzHK7XzTer1y5tUNvsTFNnB";
  
  [PXRequest setConsumerKey:consumerKey consumerSecret:consumerSecret];
  
  return YES;
}
@end
