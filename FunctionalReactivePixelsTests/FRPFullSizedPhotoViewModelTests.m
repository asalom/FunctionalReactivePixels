//
//  FRPFullSizePhotoViewControllerTests.m
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
#import "FRPFullSizedPhotoViewModel.h"

SpecBegin(FRPFullSizedPhotoViewModel)

describe(@"FRPFullSizedPhotoViewModel", ^{
  it(@"should assign correct attributes when initialized", ^{
    NSArray *model = @[];
    NSInteger initialPhotoindex = 37;
    FRPFullSizedPhotoViewModel *viewModel = [[FRPFullSizedPhotoViewModel alloc] initWithPhotoArray:model initialPhotoIndex:initialPhotoindex];
    expect(model).to.equal(viewModel.photos);
    expect(initialPhotoindex).to.equal(viewModel.initialPhotoIndex);
  });
  
  it(@"should return nil for an out-of-bounds photo index", ^{
    NSArray *model = @[[NSObject new]];
    NSInteger photoIndex = 0;
    FRPFullSizedPhotoViewModel *viewModel = [[FRPFullSizedPhotoViewModel alloc] initWithPhotoArray:model initialPhotoIndex:photoIndex];
    id subzeroModel = [viewModel photoModelAtIndex:-1];
    expect(subzeroModel).to.beNil();
    
    id aboveBoundsModel = [viewModel photoModelAtIndex:model.count];
    expect(aboveBoundsModel).to.beNil();
  });
  
  it(@"should return the correct model for photoModelAtIndex", ^{
    id photoModel = [NSObject new];
    NSArray *model = @[photoModel];
    NSInteger photoIndex = 0;
    FRPFullSizedPhotoViewModel *viewModel = [[FRPFullSizedPhotoViewModel alloc] initWithPhotoArray:model initialPhotoIndex:photoIndex];
    id returnedModel = [viewModel photoModelAtIndex:0];
    expect(photoModel).to.equal(returnedModel);
  });
  
  it(@"should return the initial photo name", ^{
    NSString *photoName = @"photo name";
    FRPPhotoModel *model = [[FRPPhotoModel alloc] init];
    model.photoName = photoName;
    
    FRPFullSizedPhotoViewModel *viewModel = [[FRPFullSizedPhotoViewModel alloc] initWithPhotoArray:@[model] initialPhotoIndex:0];
    
    expect(viewModel.initialPhotoName).to.equal(photoName);
  });
});

SpecEnd