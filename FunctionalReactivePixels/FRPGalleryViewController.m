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

static NSString *CellIdentifier = @"Cell";

@interface FRPGalleryViewController () <FRPFullSizePhotoViewControllerDelegate>
@property (nonatomic, strong) NSArray *photos;
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
  
  [self loadPopularPhotos];
}

- (void)loadPopularPhotos {
  [[FRPPhotoImporter importPhotos] subscribeNext:^(id x) {
    self.photos = x;
  } error:^(NSError *error) {
    NSLog(@"Couldn't fetch photos from 500px: %@", error);
  }];
}

#pragma mark - FRPFullSizePhotoViewControllerDelegate
- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController
       toPhotoAtIndex:(NSUInteger)index {
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                      animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  [cell setPhotoModel:self.photos[indexPath.row]];
  
  return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] initWithPhotos:self.photos currentPhotoIndex:indexPath.item];
  viewController.delegate = self;
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
