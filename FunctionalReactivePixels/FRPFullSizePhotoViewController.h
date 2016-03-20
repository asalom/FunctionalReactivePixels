//
//  FRPFullSizePhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FRPPhotoModel;

@class FRPFullSizePhotoViewController;

@protocol FRPFullSizePhotoViewControllerDelegate <NSObject>

- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController
       toPhotoAtIndex:(NSUInteger)index;

@end

@interface FRPFullSizePhotoViewController : UIViewController

- (instancetype)initWithPhotos:(NSArray<FRPPhotoModel *> *)photos currentPhotoIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSArray<FRPPhotoModel *> *photos;
@property (nonatomic, weak) id<FRPFullSizePhotoViewControllerDelegate> delegate;

@end
