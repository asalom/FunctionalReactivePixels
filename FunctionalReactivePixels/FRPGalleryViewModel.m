//
//  FRPGalleryViewModel.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPGalleryViewModel.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoImporter.h"

@interface FRPGalleryViewModel ()
@property (nonatomic, readwrite, strong) NSArray<FRPPhotoModel *> *photos;
@end

@implementation FRPGalleryViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    RAC(self, photos) = [self importPhotosSignal];
  }
  
  return self;
}

- (RACSignal *)importPhotosSignal {
  return [[[FRPPhotoImporter importPhotos] logError] catchTo:[RACSignal empty]];
}

@end
