//
//  ViewController.m
//  RottenTomatoes
//
//  Created by Gabriel Gayán on 10/20/15.
//  Copyright © 2015 Gabriel Gayán. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieDetailsViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+FadeInImages.h"
#import "MBProgressHUD.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic, getter=isHidden) IBOutlet UIView *networkErrorView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.networkErrorView setHidden:YES];
    self.title = @"Movies";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    
    [self fetchMovies];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    cell.titleLabel.text = self.movies[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.movies[indexPath.row][@"synopsis"];
    
    NSURL *url = [NSURL URLWithString:self.movies[indexPath.row][@"posters"][@"thumbnail"]];
//    [cell.posterImageView setImageWithURL:url];
    [cell.posterImageView setImageWithURLAndFadeIn:url];
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MovieCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    MovieDetailsViewController *vc = segue.destinationViewController;
    vc.movie = self.movies[indexPath.row];
    vc.placeHolderImage = cell.posterImageView.image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlString =
    @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *response =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.movies = response[@"movies"];
                                                    [self.tableView reloadData];
                                                    [self.networkErrorView setHidden:true];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    [self.networkErrorView setHidden:false];
                                                }
                                                [self.refreshControl endRefreshing];
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                            }];
    [task resume];
}

- (void)onRefresh {
    [self fetchMovies];
}

@end
