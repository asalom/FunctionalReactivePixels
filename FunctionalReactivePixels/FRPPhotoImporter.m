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

+ (RACSignal *)importPhotos {
  return [[[[[self requestPhotoData] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
    id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return [[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
      FRPPhotoModel *model = [FRPPhotoModel new];
      
      [self configurePhotoModel:model withDictionary:photoDictionary];
      [self downloadThumbnailForPhotoModel:model];
      
      return model;
    }] array];
  }] publish] autoconnect];
}

+ (RACSignal *)requestPhotoData {
  NSURLRequest *request = [self popularURLRequest];
  
  return [[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
    return data;
  }];
}

+ (NSURLRequest *)popularURLRequest {
  id apiHelper = [[PXAPIHelper alloc] initWithHost:nil consumerKey:@"DC2To2BS0ic1ChKDK15d44M42YHf9gbUJgdFoF0m" consumerSecret:@"i8WL4chWoZ4kw9fh3jzHK7XzTer1y5tUNvsTFNnB"];
  return [apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}



+ (RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel {
  NSURLRequest *request = [self photoDetailsURLRequest:photoModel];
  
  return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request]
              reduceEach:^id(NSURLResponse *response, NSData *data) {
                return data;
              }]
             deliverOn:[RACScheduler mainThreadScheduler]]
            map:^id(NSData *data) {
              id results = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:nil][@"photo"];
              [self configurePhotoModel:photoModel withDictionary:results];
              [self downloadFullsizedImageForPhotoModel:photoModel];
              return photoModel;
            }] publish] autoconnect];
}

+ (NSURLRequest *)photoDetailsURLRequest:(FRPPhotoModel *)photoModel {
  return [API urlRequestForPhotoID:photoModel.identifier.integerValue];
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
          reduceEach:^id(NSURLResponse *response, NSData *data) {
            return data;
          }]
          deliverOn:[RACScheduler mainThreadScheduler]];
}

@end
