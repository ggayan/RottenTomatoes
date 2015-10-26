//
//  UIImageView+FadeInImages.m
//  RottenTomatoes
//
//  Created by Gabriel Gayan on 15/25/10.
//  Copyright © 2015 Gabriel Gayán. All rights reserved.
//

#import "UIImageView+AFnetworking.h"
#import "UIImageView+FadeInImages.h"

@implementation UIImageView (FadeInImages)
- (void)setImageWithURLAndFadeIn:(NSURL *)url {
    [self setImageWithURLAndFadeIn:url placeholderImage:nil];
}

- (void)setImageWithURLAndFadeIn:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak typeof(self) weakSelf = self;
    [self setImageWithURLRequest:request placeholderImage:placeholderImage
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                             __strong typeof(self) strongSelf = weakSelf;
                             
                             if (strongSelf) {
                                 strongSelf.image = image;
                                 
                                 if([response statusCode] == 200){
                                     strongSelf.alpha = 0;
                                     [UIView animateWithDuration:1
                                                           delay:0.3
                                                         options:UIViewAnimationOptionCurveEaseIn
                                                      animations:^{ strongSelf.alpha = 1; }
                                                      completion:^(BOOL finished){}
                                      ];
                                 }
                             }
                         }
                         failure:nil];
    
}
@end
