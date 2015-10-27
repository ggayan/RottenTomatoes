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

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic, getter=isHidden) IBOutlet UIView *networkErrorView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *searchTerm;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.networkErrorView setHidden:YES];
    self.title = @"Movies";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setAlpha:0.6];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    
    [self fetchMovies];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:51.0/255 green:102.0/255 blue:153.0/255 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.titleLabel.text = self.filteredMovies[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.filteredMovies[indexPath.row][@"synopsis"];
    
    NSURL *url = [NSURL URLWithString:self.filteredMovies[indexPath.row][@"posters"][@"thumbnail"]];

    [cell.posterImageView setImageWithURLAndFadeIn:url];
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MovieCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    MovieDetailsViewController *vc = segue.destinationViewController;
    vc.movie = self.filteredMovies[indexPath.row];
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
                                                    [self filterMovies];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTerm = searchText;
    [self filterMovies];
}

- (void)filterMovies {
    if ([self.searchTerm length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(title CONTAINS[c] %@)", self.searchTerm];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredMovies = self.movies;
    }
    [self.tableView reloadData];
}

@end
