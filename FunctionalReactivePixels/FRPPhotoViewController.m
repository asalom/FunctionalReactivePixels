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
#import "FRPPhotoViewModel.h"

@interface FRPPhotoViewController ()
@property (nonatomic, assign) NSUInteger photoIndex;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong) FRPPhotoViewModel *viewModel;
@end

@implementation FRPPhotoViewController

- (instancetype)initWithPhotoModel:(FRPPhotoViewModel *)viewModel index:(NSUInteger)index {
  self = [super init];
  if (self) {
    self.viewModel = viewModel;
    self.photoIndex = index;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  RAC(imageView, image) = RACObserve(self.viewModel, photoImage);
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:imageView];
  self.imageView = imageView;
  
  [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber *loading){
    if (loading.boolValue) {
      [SVProgressHUD show];
    } else {
      [SVProgressHUD dismiss];
      NSLog(@"%@", self.viewModel.photoImage);
    }
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.viewModel load];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
}

@end
