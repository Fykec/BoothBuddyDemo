//
//  BarTableViewCell.m
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/23/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import "BarTableViewCell.h"
#import <AsyncImageView.h>
#import <MapKit/MapKit.h>
#import "LocationManager.h"


@interface BarTableViewCell () <UIScrollViewDelegate>
{
    UIScrollView *_scrollview;
    NSMutableArray *_imageViews;
    NSArray *_images;
    
    UILabel *_nameLabel;
    UILabel *_distanceLabel;
}


@end

#define INNER_VIEW_MARGIN 8

@implementation BarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(INNER_VIEW_MARGIN, INNER_VIEW_MARGIN, self.bounds.size.width - INNER_VIEW_MARGIN * 2, self.bounds.size.height - INNER_VIEW_MARGIN)];
        innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        innerView.layer.cornerRadius = 4;
        innerView.layer.masksToBounds = YES;
        innerView.backgroundColor = [UIColor blackColor];
        [self addSubview:innerView];
        
        _scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _scrollview.pagingEnabled = YES;
        
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.scrollsToTop = NO;
        _scrollview.delegate = self;
        [innerView addSubview:_scrollview];
        
        UIImageView *textBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        textBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        textBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.65f];
        [innerView addSubview:textBackgroundView];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [innerView addSubview:_nameLabel];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceLabel.textColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [innerView addSubview:_distanceLabel];
    }
    return self;
}

- (NSString *)distanceOfBar:(BarObject *)bar
{
    CLLocation *barLocation = [[CLLocation alloc] initWithLatitude:bar.latitude longitude:bar.longitude];
    CLLocation *currentLocation = [[LocationManager sharedInstance] fetchCurrentLocation];
    if (currentLocation)
    {
        CLLocationDistance  distance = [barLocation distanceFromLocation:currentLocation];
        CLLocationDistance miles = distance * 0.000621371192;
        NSInteger kiloMiles = miles / 1000;
        NSInteger hundrendMilesExcludeKiloMiles = (miles - kiloMiles * 1000) / 100;
        
        return [NSString stringWithFormat:@"%d,%d miles", kiloMiles, hundrendMilesExcludeKiloMiles * 100];
    }
    else
    {
        return @"";
    }
}

- (void)reloadDataWithBar:(BarObject *)bar
{
    _nameLabel.text = bar.name;
    CGSize textSize = [_nameLabel sizeThatFits:self.bounds.size];
    _nameLabel.frame = CGRectMake(6, 7, textSize.width, textSize.height);
    
    _distanceLabel.text = [self distanceOfBar:bar];
    CGSize distanceTextSize = [_distanceLabel sizeThatFits:self.bounds.size];
    _distanceLabel.frame = CGRectMake(_distanceLabel.superview.bounds.size.width - 6 - distanceTextSize.width, 7, distanceTextSize.width, distanceTextSize.height);
    
    _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width * [[bar images] count], _scrollview.frame.size.height);

    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    
    NSUInteger count = [[bar images] count];
    _images = [bar images];
    for (int i = 0; i < count; i++)
    {
        [imageViews addObject:[NSNull null]];
    }
    
    for (UIView * view in _imageViews)
    {
        [view removeFromSuperview];
    }
    
    _imageViews = imageViews;
    
    for (int i = 0; i < count; i++)
    {
        [self loadScrollViewWithPage:i];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= [_imageViews count])
        return;
    
    // replace the placeholder if necessary
    UIImageView *imageView = [_imageViews objectAtIndex:page];
    if ((NSNull *)imageView == [NSNull null])
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.imageURL = [NSURL URLWithString:[_images objectAtIndex:page]];
        [_imageViews replaceObjectAtIndex:page withObject:imageView];
    }
    
    // add the controller's view to the scroll view
    if (imageView.superview == nil)
    {
        
        CGRect frame = _scrollview.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        [_scrollview addSubview:imageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

@end
