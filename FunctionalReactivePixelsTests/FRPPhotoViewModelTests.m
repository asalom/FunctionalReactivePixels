//
//  FRPPhotoViewModelTests.m
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
#import "FRPPhotoViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

SpecBegin(FRPPhotoViewModel)

describe(@"FRPPhotoViewModel", ^{
  it(@"should return the photo's name property when photoName is invoked", ^{
    NSString *name = @"Ash";
    id mockPhotoModel = [OCMockObject mockForClass:[FRPPhotoModel class]];
    [[[mockPhotoModel stub] andReturn:name] photoName];
    FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithPhotoModel:mockPhotoModel];
    id returnedName = [viewModel photoName];
    expect(returnedName).to.equal(name);

  });
  
  it(@"should map image data to image", ^{
    
    UIImage *image = [[UIImage alloc] init];
    NSData *imageData = [NSData data];
    id mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[[mockImage stub] andReturn:image] imageWithData:imageData];
    
    FRPPhotoModel *model = [[FRPPhotoModel alloc] init];
    model.fullsizedData = imageData;
    
    FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithPhotoModel:model];
    
    [viewModel load];
    
    [mockImage verify];
  });
  
  it(@"should return the correct photo name", ^{
    NSString *name = @"Ash";
    
    FRPPhotoModel *model = [[FRPPhotoModel alloc] init];
    model.photoName = name;
    
    FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithPhotoModel:model];
    
    NSString *returnedName = [viewModel photoName];
    
    expect(name).to.equal(returnedName);
  });
});

SpecEnd