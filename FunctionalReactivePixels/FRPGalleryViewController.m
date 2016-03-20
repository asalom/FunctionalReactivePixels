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

static NSString *CellIdentifier = @"Cell";

@interface FRPGalleryViewController ()
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) id collectionViewDelegate;
@end

@implementation FRPGalleryViewController

- (instancetype)init {
  FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
  self = [super initWithCollectionViewLayout:flowLayout];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Popular on 500px";
  
  [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:CellIdentifier];
  
  @weakify(self);
  [RACObserve(self, photos) subscribeNext:^(id x) {
    @strongify(self);
    [self.collectionView reloadData];
  }];
  
  RACDelegateProxy *viewControllerDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)];
  [[viewControllerDelegate rac_signalForSelector:@selector(userDidScroll:toPhotoAtIndex:)
                                    fromProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)]
   subscribeNext:^(RACTuple *value) {
    @strongify(self)
     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[value.second integerValue]
                                                                      inSection:0]
                                 atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                         animated:NO];
  }];
  
  self.collectionViewDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegate)];
  [[self.collectionViewDelegate rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)]
   subscribeNext:^(RACTuple *arguments) {
     @strongify(self)
     FRPFullSizedPhotoViewModel *viewModel = [[FRPFullSizedPhotoViewModel alloc] initWithPhotoArray:self.photos
                                                                                  initialPhotoIndex:[arguments.second indexPath].item];
     FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] init];
     viewController.viewModel = viewModel;
     viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)self;
     [self.navigationController pushViewController:viewController animated:YES];
   }];

  RAC(self, photos) = [[[[FRPPhotoImporter importPhotos]
  doCompleted:^{
    @strongify(self);
    [self.collectionView reloadData];
  }] logError] catchTo:[RACSignal empty]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  cell.model = self.photos[indexPath.row];
  
  return cell;
}

@end
