//
//  PZViewController.m
//  QMLtest
//
//  Created by sreejith on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PZViewController.h"


@implementation PZViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    scrollView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    [self.view addSubview:scrollView];
    //self.view = scrollView;
    
    if (scrollView.dataSource == nil)
        scrollView.dataSource = self;
    if (scrollView.scrollDelegate == nil)
        scrollView.scrollDelegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (scrollView.totalCount == 0)
        [scrollView initializeScrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark QBMLDataSource methods

- (NSInteger)numberOfItemsInArrayView:(CustomScrollView *)arrayView {
    return 25;
}

- (UIView *)viewForItemInScrollView:(CustomScrollView *)arrayView atIndex:(NSInteger)index {
    DemoItemView *itemView = (DemoItemView *) [arrayView dequeueReusableItem];
    if (itemView == nil) {
        itemView = [[DemoItemView alloc] init];
        itemView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",index]];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, itemView.image.size.height-20, itemView.image.size.width, 20)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = [NSString stringWithFormat:@"Deal%i",index];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor=  [UIColor blueColor];
        [itemView addSubview:titleLabel];
        
        scrollView.itemSize = itemView.image.size;
    }
    return itemView;
}
- (NSInteger)numberOfColoumnsRequired{
    return 4;
}
- (CGFloat)gapForRow{
    return 5;
}
- (CGFloat)gapForColoumn{
    return 5;
}

#pragma mark -
#pragma mark QBMLDelegate methods

- (void)didSelectedView:(UIView *)selectedView atIndex:(NSUInteger)index {
    NSLog(@"selcted tag = %i, ",index);
    selectedView.alpha = 1;
    /*for (int i = 0; i<[[scrollView subviews]count]; i++) {
        UIView *view = [[scrollView subviews]objectAtIndex:i];
        if (![view isEqual:selectedView]) {
            view.alpha = 0.7;
        }
    }*/
    [self startAnimationForTheSelectedView:selectedView];
    
    
}

- (void)startAnimationForTheSelectedView:(UIView *)selectedView
{
    [UIView animateWithDuration:0.1
                          delay:0 options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse | 
     UIViewAnimationOptionRepeat
                     animations:^{
                         [UIView setAnimationRepeatCount:2];
                         selectedView.transform = CGAffineTransformMakeRotation(0.2); 
                         selectedView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         selectedView.transform = CGAffineTransformMakeRotation(-0.2);
                         
                     }
                     completion:^(BOOL finished){
                         selectedView.transform = CGAffineTransformIdentity;  
                         
                     }];
    
}
- (IBAction)refresh:(id)sender
{
    [scrollView refreshScrollView];
}
@end
