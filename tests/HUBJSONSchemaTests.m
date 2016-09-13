#import <XCTest/XCTest.h>

#import "HUBJSONSchemaImplementation.h"
#import "HUBViewModelBuilderImplementation.h"
#import "HUBViewModelImplementation.h"
#import "HUBComponentModel.h"
#import "HUBComponentDefaults+Testing.h"
#import "HUBIconImageResolverMock.h"

@interface HUBJSONSchemaTests : XCTestCase

@end

@implementation HUBJSONSchemaTests

- (void)testViewModelFromJSONDictionary
{
    HUBComponentDefaults * const componentDefaults = [HUBComponentDefaults defaultsForTesting];
    id<HUBIconImageResolver> const iconImageResolver = [HUBIconImageResolverMock new];
    
    HUBJSONSchemaImplementation * const schema = [[HUBJSONSchemaImplementation alloc] initWithComponentDefaults:componentDefaults
                                                                                              iconImageResolver:iconImageResolver];
    
    HUBViewModelBuilderImplementation * const builder = [[HUBViewModelBuilderImplementation alloc] initWithJSONSchema:schema
                                                                                                    componentDefaults:componentDefaults
                                                                                                    iconImageResolver:iconImageResolver];
    
    NSDictionary * const dictionary = @{
        @"body": @[
            @{
                @"component": @"namespace:name",
                @"title": @"A title"
            }
        ]
    };
    
    [builder addDataFromJSONDictionary:dictionary];
    
    id<HUBViewModel> const viewModelFromSchema = [schema viewModelFromJSONDictionary:dictionary];
    id<HUBViewModel> const viewModelFromBuilder = [builder build];
    
    XCTAssertEqual(viewModelFromSchema.bodyComponentModels.count, viewModelFromBuilder.bodyComponentModels.count);
    XCTAssertEqualObjects([viewModelFromSchema.bodyComponentModels firstObject].title, [viewModelFromBuilder.bodyComponentModels firstObject].title);
}

- (void)testCopy
{
    HUBComponentDefaults * const componentDefaults = [HUBComponentDefaults defaultsForTesting];
    id<HUBIconImageResolver> const iconImageResolver = [HUBIconImageResolverMock new];
    id<HUBJSONSchema> const schema = [[HUBJSONSchemaImplementation alloc] initWithComponentDefaults:componentDefaults iconImageResolver:iconImageResolver];
    id<HUBJSONSchema> const copy = [schema copy];
    
    // Assert that the copied sub schemas are not the same instance as the original ones
    XCTAssertNotEqual(schema.viewModelSchema, copy.viewModelSchema);
    XCTAssertNotEqual(schema.componentModelSchema, copy.componentModelSchema);
    XCTAssertNotEqual(schema.componentImageDataSchema, copy.componentImageDataSchema);
}

@end