//
//  FRPPhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FRPPhotoModel;
@class FRPPhotoViewModel;

@interface FRPPhotoViewController : UIViewController

- (instancetype)initWithPhotoModel:(FRPPhotoViewModel *)viewModel index:(NSUInteger)index;

@property (nonatomic, readonly) FRPPhotoModel *photoModel;
@property (nonatomic, readonly) NSUInteger photoIndex;

@end
