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
#import "BKPlayListDataController.h"


@implementation BKPlayListViewController
{
    BKPlayListDataController *mDataController;
}


- (instancetype)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mDataController = [[BKPlayListDataController alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mDataController release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Playlists"];
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
    return [mDataController numberOfPlaylist];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell = [aTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:aIndexPath];
    
    [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [[sCell textLabel] setText:[mDataController playlistTitleAtIndex:[aIndexPath row]]];
    
    return sCell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


@end
