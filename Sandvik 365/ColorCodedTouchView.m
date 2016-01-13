//
//  ColorCodedTouchView.m
//  ColorCoding
//
//  Created by Karl Söderström on 2012-09-12.
//  Copyright (c) 2012 Karl Söderström. All rights reserved.
//

#import "ColorCodedTouchView.h"
#import "ColorCodingLookup.h"

@interface ColorCodedTouchView ()
@property ColorCodingLookup *colorCodingLookup;
@property NSMutableDictionary *colorGestureRecognizers;
@property NSCache *colorCache;
@end

@implementation ColorCodedTouchView

- (id)initWithFrame:(CGRect)frame colorCodingImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colorCodingLookup = [ColorCodingLookup colorCodingLookupWithImageName:imageName targetSize:frame.size];
        self.colorGestureRecognizers = [NSMutableDictionary dictionary];
        self.colorCache = [[NSCache alloc] init];
        self.colorCache.countLimit = 10;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.colorCodingLookup.targetSize = frame.size;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer forColor:(UIColor *)color
{
    [self.colorGestureRecognizers setObject:color forKey:[NSValue valueWithNonretainedObject:gestureRecognizer]];
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self];
    id color = [self.colorCache objectForKey:[NSValue valueWithCGPoint:location]];
    if (color == nil) {
        color = [self.colorCodingLookup colorForPoint:location];
        if (color == nil) {
            color = [NSNull null];
        }
        [self.colorCache setObject:color forKey:[NSValue valueWithCGPoint:location]];
    }
    
    return (color != nil && color != [NSNull null] && [color isEqual:[self.colorGestureRecognizers objectForKey:[NSValue valueWithNonretainedObject:gestureRecognizer]]]);
}


@end
