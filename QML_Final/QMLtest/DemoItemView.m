//
//  DemoItemView.m
//  QMLtest
//
//  Created by sreejith on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h> 

#import "DemoItemView.h"


@implementation DemoItemView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.layer.cornerRadius = 8;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1;
        self.layer.backgroundColor = [[UIColor grayColor] CGColor];
        self.opaque = NO;
		
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    
    NSLog(@"image= %d",self.tag);
}



/*
- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;

    NSString *label = [NSString stringWithFormat:@"%02d", self.tag];
    UIFont *font = [UIFont boldSystemFontOfSize:17];

    CGSize textSize = [label sizeWithFont:font];

    [[UIColor blueColor] set];
    [label drawAtPoint:CGPointMake((size.width - textSize.width) / 2,
                                   (size.height - textSize.height) / 2) withFont:font];
}

*/
@end
