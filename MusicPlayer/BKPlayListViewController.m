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

}


- (instancetype)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[BKMotionController sharedController] start];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];
    
    [[BKMotionController sharedController] setDelegate:self];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [[BKMotionController sharedController] setDelegate:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


@end
