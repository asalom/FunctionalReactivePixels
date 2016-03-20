//
//  FRPFullSizedPhotoViewModel.h
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPFullSizedPhotoViewModel : NSObject

- (instancetype)initWithPhotoArray:(NSArray<FRPPhotoModel *> *)photoArray
                 initialPhotoIndex:(NSInteger)index;

- (FRPPhotoModel *)photoModelAtIndex:(NSInteger)index;

@property (nonatomic, readonly, strong) NSArray<FRPPhotoModel *> *photos;
@property (nonatomic, readonly) NSInteger initialPhotoIndex;
@property (nonatomic, readonly, copy) NSString *initialPhotoName;

@end
