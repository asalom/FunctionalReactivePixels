//
//  FRPCell.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPCell.h"
#import "FRPPhotoModel.h"

@interface FRPCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) RACDisposable *subscription;

@end

@implementation FRPCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor darkGrayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
  }
  return self;
}

- (void)setPhotoModel:(FRPPhotoModel *)model {
  self.subscription = [[[RACObserve(model, thumbnailData) filter:^BOOL(id value) {
    return value != nil;
  }] map:^id(id value) {
    return [UIImage imageWithData:value];
  }] setKeyPath:@keypath(self.imageView.image)
                       onObject:self];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  
  [self.subscription dispose];
  self.subscription = nil;
}

@end
