//
//  MoviewsTableViewCell.h
//  RottenTomatoes
//
//  Created by Gabriel Gayán on 10/20/15.
//  Copyright © 2015 Gabriel Gayán. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end
