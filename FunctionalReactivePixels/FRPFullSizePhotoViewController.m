//
//  FRPFullSizePhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPFullSizePhotoViewController.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoViewController.h"
#import "FRPFullSizedPhotoViewModel.h"
#import "FRPPhotoViewModel.h"

@interface FRPFullSizePhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end

@implementation FRPFullSizePhotoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
  
  self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                          options:@{UIPageViewControllerOptionInterPageSpacingKey: @30}];
  self.pageViewController.dataSource = self;
  self.pageViewController.delegate = self;
  [self addChildViewController:self.pageViewController];
  [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:self.viewModel.initialPhotoIndex]]
                                    direction:UIPageViewControllerNavigationDirectionForward
                                     animated:NO
                                   completion:nil];
  
  self.title = self.viewModel.initialPhotoName;
  
  self.pageViewController.view.frame = self.view.bounds;
  [self.view addSubview:self.pageViewController.view];
}

- (FRPPhotoViewController *)photoViewControllerForIndex:(NSInteger)index {
  if (index >= 0 && index < self.viewModel.photos.count) {
    FRPPhotoModel *photoModel = self.viewModel.photos[index];
    FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithPhotoModel:photoModel];
    return [[FRPPhotoViewController alloc] initWithPhotoModel:viewModel index:index];
  }
  
  return nil;
}

#pragma mark - UIPageViewControllerDataSource

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
  self.title = [self.pageViewController.viewControllers.firstObject photoModel].photoName;
  [self.delegate userDidScroll:self toPhotoAtIndex:[self.pageViewController.viewControllers.firstObject photoIndex]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(FRPPhotoViewController *)viewController {
  return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(FRPPhotoViewController *)viewController {
  return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

@end
