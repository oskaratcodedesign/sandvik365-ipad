//
//  ColorCodingLookup.m
//  ColorCoding
//
//  Created by Karl Söderström on 2012-09-12.
//  Copyright (c) 2012 Karl Söderström. All rights reserved.
//

#import "ColorCodingLookup.h"

@interface ColorCodingLookup ()
@property UIImage *image;
@end

@implementation ColorCodingLookup
+ (id)colorCodingLookupWithImageName:(NSString *)imageName
{
    return [[self alloc] initWithImageName:imageName];
}

+ (id)colorCodingLookupWithImageName:(NSString *)imageName targetSize:(CGSize)size
{
    return [[self alloc] initWithImageName:imageName targetSize:size];
}

+ (id)colorCodingLookupWithImage:(UIImage *)image
{
    return [[self alloc] initWithImage:image];
}

+ (id)colorCodingLookupWithImage:(UIImage *)image targetSize:(CGSize)size
{
    return [[self alloc] initWithImage:image targetSize:size];
}

- (id)initWithImageName:(NSString *)imageName
{
    return [self initWithImageName:imageName targetSize:CGSizeZero];
}

- (id)initWithImageName:(NSString *)imageName targetSize:(CGSize)size
{
    return [self initWithImage:[UIImage imageNamed:imageName] targetSize:size];
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image targetSize:CGSizeZero];
}

- (id)initWithImage:(UIImage *)image targetSize:(CGSize)size
{
    if ((self = [self init])) {
        self.image = image;
        self.targetSize = size;
    }
    return self;    
}


- (UIColor *)colorForPoint:(CGPoint)point
{
    NSSet *colors = [self colorsForRect:CGRectMake(point.x, point.y, 1, 1)];
    return [colors anyObject];
}

- (NSSet *)colorsForRect:(CGRect)rect
{
    NSMutableSet *result = [NSMutableSet set];
    
    if (!CGSizeEqualToSize(self.targetSize, CGSizeZero)) {
        CGFloat aspectW = self.image.size.width / self.targetSize.width;
        CGFloat aspectH = self.image.size.height / self.targetSize.height;
        rect = CGRectMake(floorf(rect.origin.x * aspectW),
                          floorf(rect.origin.y * aspectH),
                          MAX(1, roundf(rect.size.width * aspectW)),
                          MAX(1, roundf(rect.size.height * aspectH)));
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * rect.size.width;
    NSUInteger bitsPerComponent = 8;
    
    unsigned char *rawData = calloc(rect.size.width * rect.size.height * bytesPerPixel, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, rect.size.width, rect.size.height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsPushContext(context);
    [self.image drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    UIGraphicsPopContext();

    CGContextRelease(context);
    
    for (int i = 0; i < rect.size.width * rect.size.height * 4; i += 4) {
        NSUInteger r = rawData[i];
        NSUInteger g = rawData[i + 1];
        NSUInteger b = rawData[i + 2];
        NSUInteger a = rawData[i + 3];
        if (a > 0) {
            UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
            [result addObject:color];
        }
    }
    free(rawData);
    
    return result;
}

@end
