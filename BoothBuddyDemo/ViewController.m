//
//  ViewController.m
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import "ViewController.h"
#import "BarDataManager.h"
#import "BarObject.h"
#import "BarTableViewCell.h"


@interface ViewController () <EGORefreshTableHeaderDelegate, BarDataDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *_tableView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    
    BarDataManager *_dataManager;
}


@end

@implementation ViewController

#define TABLEVIEW_BOTTOM_MARGIN 8

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CONTENT_TOP_MARGIN, view.bounds.size.width, view.bounds.size.height - CONTENT_TOP_MARGIN - TABLEVIEW_BOTTOM_MARGIN) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [view addSubview:tableView];
    self.view = view;
    _tableView = tableView;
}

- (UITableView *)tableView
{
    return (UITableView *)_tableView;
}


//- (void)viewWillLayoutSubviews
//{
//    self.view.frame = CGRectMake(0, CONTENT_TOP_MARGIN, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CONTENT_TOP_MARGIN);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
    
    if (_dataManager == nil)
    {
        _dataManager = [[BarDataManager alloc] init];
        _dataManager.delegate = self;
    }
	
	//  update the last update date
	[self reloadTableViewDataSource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataManager bars] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    BarTableViewCell *cell = (BarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BarObject *bar = ((BarObject *)[[_dataManager bars] objectAtIndex:indexPath.row]);
    [cell reloadDataWithBar:bar];
    
	// Configure the cell.
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _reloading = YES;
	
    [_dataManager startLoadDataIfNeed];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark BarDataLoadDelegate

- (void)barDataDidLoadFinishedIsCache:(BOOL)isCache
{
    [self.tableView reloadData];
    if (!isCache)
    {
        [self doneLoadingTableViewData];
    }
}

- (void)barDataDidLoadFailed:(NSError *)error
{
    
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
}

@end
