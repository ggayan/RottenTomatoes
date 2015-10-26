//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Gabriel Gayán on 10/20/15.
//  Copyright © 2015 Gabriel Gayán. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    
    float afterResize = self.synopsisLabel.bounds.size.height;
    [self.synopsisLabel sizeToFit];
    float beforeResize = self.synopsisLabel.bounds.size.height;
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    self.scrollView.contentSize = CGSizeMake(scrollViewSize.width, scrollViewSize.height +
                                             MAX(0.0, beforeResize - afterResize));
    
    CGRect contentRect = self.contentView.frame;
    contentRect.size.height = self.scrollView.bounds.size.height;
    self.contentView.frame = contentRect;
    
    NSString *lowResUrl = self.movie[@"posters"][@"thumbnail"];
    NSRange range = [lowResUrl rangeOfString:@".*cloudfront.net/"
                                     options:NSRegularExpressionSearch];
    NSString *highResUrl = [lowResUrl stringByReplacingCharactersInRange:range
                                                              withString:@"https://content6.flixster.com/"];
    NSURL *url = [NSURL URLWithString:highResUrl];
    [self.imageView setImageWithURL:url placeholderImage:self.placeHolderImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
