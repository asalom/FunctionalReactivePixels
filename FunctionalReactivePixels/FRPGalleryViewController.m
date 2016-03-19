//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 19/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryFlowLayout.h"

@interface FRPGalleryViewController ()

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
}

@end
