//
//  ColorCodedTouchView.h
//  ColorCoding
//
//  Created by Karl Söderström on 2012-09-12.
//  Copyright (c) 2012 Karl Söderström. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * ColorCodedTouchView provides functionality to register gesture recognizers
 * to particular colors of a color map image.
 */
@interface ColorCodedTouchView : UIView <UIGestureRecognizerDelegate>

- (id)initWithFrame:(CGRect)frame colorCodingImageName:(NSString *)imageName;

/** Register a gesture recognizer for a particular color.
 * @param gestureRecognizer The gesture recognizer to registered.
 * @param color The color for which to register the recognizer.
 * @warning The delegate of the UIGestureRecognizer will be overridden, and thus
 * should not be used.
 */
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer forColor:(UIColor *)color;
@end
