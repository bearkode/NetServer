/*
 *  BKPlayListViewController.m
 *  NetServer
 *
 *  Created by bearkode on 2015. 5. 4..
 *  Copyright (c) 2015 bearkode. All rights reserved.
 *
 */

#import "BKPlayListViewController.h"



@implementation BKPlayListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
