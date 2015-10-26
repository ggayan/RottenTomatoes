//
//  MovieDetailsViewController.h
//  RottenTomatoes
//
//  Created by Gabriel Gayán on 10/20/15.
//  Copyright © 2015 Gabriel Gayán. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) NSDictionary *movie;
@property (strong, nonatomic) IBOutlet UIImage *placeHolderImage;
@end
