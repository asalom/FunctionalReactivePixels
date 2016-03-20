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

@interface FRPFullSizePhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) NSArray<FRPPhotoModel *> *photos;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end

@implementation FRPFullSizePhotoViewController

- (instancetype)initWithPhotos:(NSArray<FRPPhotoModel *> *)photos currentPhotoIndex:(NSUInteger)index
{
  self = [super init];
  if (self) {
    self.photos = photos;
    self.title = self.photos[index].photoName;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:@{UIPageViewControllerOptionInterPageSpacingKey: @30}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:index]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
  
  self.pageViewController.view.frame = self.view.bounds;
  [self.view addSubview:self.pageViewController.view];
}

- (FRPPhotoViewController *)photoViewControllerForIndex:(NSInteger)index {
  if (index >= 0 && index < self.photos.count) {
    FRPPhotoModel *photoModel = self.photos[index];
    return [[FRPPhotoViewController alloc] initWithPhotoModel:(FRPPhotoModel *)photoModel index:index];
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
