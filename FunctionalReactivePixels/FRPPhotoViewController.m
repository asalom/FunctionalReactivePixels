//
//  FRPPhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPPhotoViewController.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoImporter.h"
#import <SVProgressHUD.h>

@interface FRPPhotoViewController ()
@property (nonatomic, strong) FRPPhotoModel *photoModel;
@property (nonatomic, assign) NSUInteger photoIndex;

@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation FRPPhotoViewController

- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSUInteger)index {
  self = [super init];
  if (self) {
    self.photoModel = photoModel;
    self.photoIndex = index;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  RAC(imageView, image) = [RACObserve(self.photoModel, fullsizedData)
                           map:^id(id value) {
                             return [UIImage imageWithData:value];
                           }];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:imageView];
  self.imageView = imageView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [SVProgressHUD show];
  
  [[FRPPhotoImporter fetchPhotoDetails:self.photoModel]
   subscribeError:^(NSError *error) {
     [SVProgressHUD showErrorWithStatus:@"Error"];
   } completed:^{
     [SVProgressHUD dismiss];
   }];
}

@end
