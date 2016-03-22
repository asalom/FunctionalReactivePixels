//
//  FRPGalleryViewModelTests.m
//  FunctionalReactivePixels
//
//  Created by Alex Salom on 22/3/16.
//  Copyright © 2016 Alex Salom © alexsalom.es. All rights reserved.
//


#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import "FRPPhotoModel.h"
#import "FRPGalleryViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FRPGalleryViewModel ()
- (RACSignal *)importPhotosSignal;
@end

SpecBegin(FRPGalleryViewModel)

describe(@"FRPFullSizedPhotoViewModel", ^{
  it(@"should be initialized and call import photos", ^{
    id mockObject = [OCMockObject mockForClass:[FRPGalleryViewModel class]];
    [[[mockObject expect] andReturn:[RACSignal empty]] importPhotosSignal];
    
    mockObject = [mockObject init];
    [mockObject verify];
    [mockObject stopMocking];
  });
});

SpecEnd