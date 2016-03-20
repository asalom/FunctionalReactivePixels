//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 19/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPCell.h"
#import "FRPPhotoImporter.h"
#import "FRPFullSizePhotoViewController.h"
#import "FRPFullSizedPhotoViewModel.h"
#import <ReactiveCocoa/RACDelegateProxy.h>
#import "FRPGalleryViewModel.h"

static NSString *CellIdentifier = @"Cell";

@interface FRPGalleryViewController ()
@property (nonatomic, strong) FRPGalleryViewModel *viewModel;
@end

@implementation FRPGalleryViewController

- (instancetype)init {
  FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
  self = [super initWithCollectionViewLayout:flowLayout];
  if (self) {
    self.viewModel = [[FRPGalleryViewModel alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Popular on 500px";
  
  [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:CellIdentifier];
  
  @weakify(self);
  [RACObserve(self.viewModel, photos) subscribeNext:^(id x) {
    @strongify(self);
    [self.collectionView reloadData];
  }];
  
  [[self rac_signalForSelector:@selector(userDidScroll:toPhotoAtIndex:)
                  fromProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)]
   subscribeNext:^(RACTuple *value) {
    @strongify(self)
     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[value.second integerValue]
                                                                      inSection:0]
                                 atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                         animated:NO];
  }];
  
  [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)]
   subscribeNext:^(RACTuple *arguments) {
     @strongify(self)
     NSIndexPath *indexPath = arguments.second;
     FRPFullSizedPhotoViewModel *viewModel = [[FRPFullSizedPhotoViewModel alloc] initWithPhotoArray:self.viewModel.photos
                                                                                  initialPhotoIndex:indexPath.item];
     FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] init];
     viewController.viewModel = viewModel;
     viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)self;
     [self.navigationController pushViewController:viewController animated:YES];
   }];

  self.collectionView.delegate = nil;
  self.collectionView.delegate = self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.viewModel.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  cell.model = self.viewModel.photos[indexPath.row];
  
  return cell;
}

@end
