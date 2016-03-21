//
//  FRPPhotoViewModel.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 21/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPPhotoViewModel.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoImporter.h"

@interface FRPPhotoViewModel ()
@property (nonatomic, readwrite, strong) FRPPhotoModel *photoModel;
@property (nonatomic, readwrite, strong) UIImage *photoImage;
@property (nonatomic, readwrite, getter=isLoading) BOOL loading;
@end

@implementation FRPPhotoViewModel

- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel {
  self = [super init];
  if (self) {
    self.photoModel = photoModel;
  }
  return self;
}

- (void)load {
  @weakify(self);
  self.loading = YES;
  [[FRPPhotoImporter fetchPhotoDetails:self.photoModel]
   subscribeError:^(NSError *error) {
     NSLog(@"Could not fetch photo details: %@",error);
   } completed:^{
     @strongify(self);
     self.loading = NO;
     NSLog(@"Fetched photo details");
   }];
  
  RAC(self, photoImage) = [RACObserve(self.photoModel, fullsizedData)
                           map:^id(id value) {
                             return [UIImage imageWithData:value];
                           }];
}

- (NSString *)photoName {
  return self.photoModel.photoName;
}

@end
