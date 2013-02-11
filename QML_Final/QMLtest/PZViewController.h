//
//  PZViewController.h
//  QMLtest
//
//  Created by sreejith on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"
#import "DemoItemView.h"

@interface PZViewController : UIViewController<QBMLayoutDataSource,QBMLayoutDelegate>
{
    CustomScrollView *scrollView;
    int previousTag;
}
- (void)startAnimationForTheSelectedView:(UIView *)selectedView;
- (IBAction)refresh:(id)sender;
@end
