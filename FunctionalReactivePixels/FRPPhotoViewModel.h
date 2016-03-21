//
//  FRPPhotoViewModel.h
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 21/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FRPPhotoModel;

@interface FRPPhotoViewModel : NSObject

- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel;

@property (nonatomic, readonly, strong) FRPPhotoModel *photoModel;
@property (nonatomic, readonly) UIImage *photoImage;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) NSString *photoName;

- (void)load;

@end
