//
//  UIImageView+FadeInImages.h
//  RottenTomatoes
//
//  Created by Gabriel Gayan on 15/25/10.
//  Copyright © 2015 Gabriel Gayán. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (FadeInImages)

- (void)setImageWithURLAndFadeIn:(NSURL *)url;

- (void)setImageWithURLAndFadeIn:(NSURL *)url
       placeholderImage:(nullable UIImage *)placeholderImage;

NS_ASSUME_NONNULL_END
@end
