//
//  ColorCodingLookup.h
//  ColorCoding
//
//  Created by Karl Söderström on 2012-09-12.
//  Copyright (c) 2012 Karl Söderström. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * ColorCodingLookup provides functionality to lookup the color code of a
 * particular pixel, or all the colors of a rectangle, in a color mapping
 * image.
 */
@interface ColorCodingLookup : NSObject

/** The target size of the coordinate system. The provided color mapping image
 * may be of a different size and the translation is done automatically.
 */
@property CGSize targetSize;

+ (id)colorCodingLookupWithImageName:(NSString *)imageName;
+ (id)colorCodingLookupWithImageName:(NSString *)imageName targetSize:(CGSize)size;
+ (id)colorCodingLookupWithImage:(UIImage *)image;
+ (id)colorCodingLookupWithImage:(UIImage *)image targetSize:(CGSize)size;

- (id)initWithImageName:(NSString *)imageName;
- (id)initWithImageName:(NSString *)imageName targetSize:(CGSize)size;
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image targetSize:(CGSize)size;

/** Queries the color of the provided point.
 * @param point The point to be queried in the targetSize coordinate system.
 * @return The color of point, or nil if the alpha value of the color is zero.
 */
- (UIColor *)colorForPoint:(CGPoint)point;

/** Queries a set with all the colors within the provided rect in the targetSize
 * coordinate system.
 * @param rect The rectangle to be queried in the targetSize coordinate system.
 * @return A set of colors within the rectangle. Colors with a alpha value of zero are not included.
 */
- (NSSet *)colorsForRect:(CGRect)rect;

@end
