//
//  FRPPhotoModel.h
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPPhotoModel : NSObject

@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *photographerName;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSData *thumbnailData;
@property (nonatomic, copy) NSString *fullsizedURL;
@property (nonatomic, copy) NSString *fullsizedData;

@end
