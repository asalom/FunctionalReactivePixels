//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 20/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter

+ (RACReplaySubject *)importPhotos {
  RACReplaySubject *subject = [RACReplaySubject subject];
  
  NSURLRequest *request = [self popularURLRequest];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                           if (data) {
                             id results = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:nil];
                             [subject sendNext:[[[results[@"photos"] rac_sequence] map:^id(id value) {
                               FRPPhotoModel *model = [FRPPhotoModel new];
                               [self configurePhotoModel:model withDictionary:value];
                               [self downloadThumbnailForPhotoModel:model];
                               return model;
                             }] array]];
                             [subject sendCompleted];
                           } else {
                             [subject sendError:connectionError];
                           }
                         }];
  return subject;
}

+ (NSURLRequest *)popularURLRequest {
  return [APP.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular
                                   resultsPerPage:100
                                             page:0
                                       photoSizes:PXPhotoModelSizeThumbnail
                                        sortOrder:PXAPIHelperSortOrderRating
                                           except:PXPhotoModelCategoryNude];
}



+ (RACReplaySubject *)fetchPhotoDetails:(FRPPhotoModel *)photoModel {
  RACReplaySubject *subject = [RACReplaySubject subject];
  
  NSURLRequest *request = [self photoDetailsURLRequest:photoModel];
  
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                           if (data) {
                             id results = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:nil][@"photo"];
                             [self configurePhotoModel:photoModel withDictionary:results];
                             [self downloadFullsizedImageForPhotoModel:photoModel];
                             [subject sendNext:photoModel];
                             [subject sendCompleted];
                           } else {
                             [subject sendError:connectionError];
                           }
                         }];
  
  return subject;
}

+ (NSURLRequest *)photoDetailsURLRequest:(FRPPhotoModel *)photoModel {
  return [APP.apiHelper urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+ (void)configurePhotoModel:(FRPPhotoModel *)photoModel withDictionary:(NSDictionary *)dictionary {
  // Basics details fetched with the first, basic request
  photoModel.photoName = dictionary[@"name"];
  photoModel.identifier = dictionary[@"id"];
  photoModel.photographerName = dictionary[@"user"][@"username"];
  photoModel.rating = dictionary[@"rating"];
  
  photoModel.thumbnailURL = [self urlForImageSize:3 inArray:dictionary[@"images"]];
  
  // Extended attributes fetched with subsequent request
  if (dictionary[@"comments_count"]) {
    photoModel.fullsizedURL = [self urlForImageSize:4 inArray:dictionary[@"images"]];
  }
}

+ (NSString *)urlForImageSize:(NSInteger)size inArray:(NSArray *)array {
  /*
    (
      {
        size = 3;
        url = "http://ppcdn.500px.org/49204370/b125a49d0863e0ba05d8196072b055876159f33e/3.jpg";
      }
    );
   */
  
  return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
    return [value[@"size"] integerValue] == size;
  }] map:^id(id value) {
    return value[@"url"];
  }] array] firstObject];
}

+ (void)downloadThumbnailForPhotoModel:(FRPPhotoModel *)photoModel {
  RAC(photoModel, thumbnailData) = [self download:photoModel.thumbnailURL];
}

+ (void)downloadFullsizedImageForPhotoModel:(FRPPhotoModel *)photoModel {
  RAC(photoModel, fullsizedData) = [self download:photoModel.fullsizedURL];
}

+ (RACSignal *)download:(NSString *)urlString {
  NSAssert(urlString, @"urlString must not be nil");
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  
  return [[[NSURLConnection rac_sendAsynchronousRequest:request]
          map:^id(RACTuple *value) {
            return value.second;
          }]
          deliverOn:[RACScheduler mainThreadScheduler]];
}

@end
