/*
 *  BKPlayListViewController.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 4..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKPlayListViewController.h"
#import "BKMotionController.h"


@implementation BKPlayListViewController
{
    UIImageView        *mHandView;
    BKMotionController *mMotionController;
}


- (instancetype)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mMotionController = [[BKMotionController alloc] init];
        [mMotionController setDelegate:self];
    }
    
    return self;
}


- (void)dealloc
{
    [mMotionController release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    mHandView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 45)]autorelease];
    [[self view] addSubview:mHandView];
    
    [mMotionController start];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ![[self view] window])
    {
        mHandView = nil;
    }
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell = [aTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:aIndexPath];
    
    return sCell;
}


- (void)motionController:(BKMotionController *)aMotionController didReceiveMotion:(BKFrame *)aFrame
{
    NSLog(@"sFrame = %@", aFrame);
    
    NSInteger sCount     = [aFrame extenedFingerCount];
    NSString *sImageName = [NSString stringWithFormat:@"%d", (int)sCount];
    
    [mHandView setImage:[UIImage imageNamed:sImageName]];
    
    CGRect  sBounds   = [[self view] bounds];
    CGPoint sPosition = CGPointMake([[aFrame palmPosition] x], [[aFrame palmPosition] z]);
    CGPoint sMid      = CGPointMake(CGRectGetMidX(sBounds), CGRectGetMidY(sBounds));
    
    sPosition.x *= 3.0;
    sPosition.y *= 3.0;
    sPosition.x += sMid.x;
    sPosition.y += sMid.y;
    
    CGRect sFrame = [mHandView frame];
    sFrame.origin.x = 100;
    sFrame.origin.y = 100;
    [mHandView setFrame:sFrame];
    [mHandView setCenter:sPosition];
}


@end
