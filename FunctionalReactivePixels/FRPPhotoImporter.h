//
//  FRPPhotoImporter.h
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FRPPhotoModel;

@interface FRPPhotoImporter : NSObject

+ (RACSignal *)importPhotos;
+ (RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel;

@end
