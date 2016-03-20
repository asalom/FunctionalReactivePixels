//
//  FRPFullSizedPhotoViewModel.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPFullSizedPhotoViewModel.h"
#import "FRPPhotoModel.h"

@interface FRPFullSizedPhotoViewModel ()
@property (nonatomic, readwrite, strong) NSArray<FRPPhotoModel *> *photos;
@property (nonatomic, readwrite) NSInteger initialPhotoIndex;
@property (nonatomic, readwrite, copy) NSString *initialPhotoName;
@end

@implementation FRPFullSizedPhotoViewModel

- (instancetype)initWithPhotoArray:(NSArray<FRPPhotoModel *> *)photoArray
                 initialPhotoIndex:(NSInteger)index {
  if (self = [super init]) {
    self.photos = photoArray;
    self.initialPhotoIndex = index;
  }
  
  return self;
}

- (NSString *)initialPhotoName {
  return self.photos[self.initialPhotoIndex].photoName;
}

- (FRPPhotoModel *)photoModelAtIndex:(NSInteger)index {
  if (index >= 0 && index < self.photos.count) {
    return self.photos[index];
  }
  
  return nil;
}

@end
