//
//  TrackListViewController.m
//  SpotifyChart
//
//  Created by Sonia Reddy Kolli on 02/26/16.
//  Copyright (c) 2016 Sonia Reddy Kolli. All rights reserved.
//

#import "TrackListViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MBProgressHUD.h"
#import "Defines.h"
#import "Track.h"
#import "TrackItemCell.h"
#import "TrackDetailsViewController.h"

@interface TrackListViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *progressView;
    NSMutableArray *tracks;
}

@end

@implementation TrackListViewController

@synthesize trackListTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self downloadLatestGeneralTracks];
    self.title = @"Spotify Charts";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadLatestGeneralTracks{
    
    NSString *urlString = @"https://spotifycharts.com/api/?type=regional&country=global&recurrence=daily&date=latest&limit=50&offset=0";
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    //completion block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Successfully received tracks");
        
        if (nil == tracks) {
            
            tracks = [[NSMutableArray alloc] initWithCapacity:50]; //currently we are supporting 50 only in list
        }
        
        NSDictionary *entries = [responseObject objectForKey:KEY_ENTRIES];
        NSArray *items = [entries objectForKey:KEY_ITEMS];
        
        for (NSDictionary *item in items) {
            
            Track *trackItem = [[Track alloc] init];
            
            //current& previous position And Playcount
            
            trackItem.currentPosition = [[item objectForKey:KEY_CURRPOS] integerValue];
            trackItem.prevousPosition = [[item objectForKey:KEY_PREVPOS] integerValue];
            trackItem.playCount = [[item objectForKey:KEY_PLAYS] doubleValue];
            
            //read track
            NSDictionary *track = [item objectForKey:KEY_TRACK];
            
            
            trackItem.previewUrl = [track objectForKey:KEY_PREVIEW_URL];
            trackItem.trackDetailsUrl = [track objectForKey:KEY_TRACK_URL];
            
            //album
            NSDictionary *album = [track objectForKey:KEY_ALBUM_ALBUM];
            trackItem.albumId = [album objectForKey:KEY_ID];
            trackItem.name = [album objectForKey:KEY_NAME];
            trackItem.duration = [[track objectForKey:KEY_DURATION_MS] doubleValue];
            
            //images
            NSArray *imageUrls = [album objectForKey:KEY_ALBUM_IMAGES];
            NSDictionary *itemDict =    [imageUrls objectAtIndex:1] ;
            trackItem.imageUrl = [itemDict objectForKey:KEY_ALBUM_IMAGE_URL];
            
            //artists
            NSArray *artists = [track objectForKey:KEY_ARTISTS];
            trackItem.artists = [[NSMutableArray alloc] initWithCapacity:artists.count];
            
            for (NSDictionary *obj in artists) {
                NSString *artistName = [obj objectForKey:KEY_NAME];
                [trackItem.artists addObject:artistName];
            }
            
            [tracks addObject:trackItem];
        }
        
        [progressView removeFromSuperview];
        [trackListTableView reloadData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"contact download failed   with reason = %@",error);
        [progressView removeFromSuperview];
        [trackListTableView reloadData];
    }];
    
    [operation start];
    
    progressView = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:progressView];
    
    progressView.delegate = self;
    progressView.labelText = @"Fetching Track Chart...";
    [progressView show:YES];
  
}


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove progressView from screen when the progressView was hidded
    [progressView removeFromSuperview];
    progressView = nil;
}

#pragma mark -
#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return tracks.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push your view controlle to move to next view controller
    NSLog(@"push view controller");
    
    TrackDetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackDetailsViewController"];
    detailVC.selectedTrack = [tracks objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TrackItemCell";
    TrackItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    Track *listItem = [tracks objectAtIndex:indexPath.row];
    cell.nameVal.text = listItem.name;
    cell.currPosVal.text = [NSString stringWithFormat:@"%ld",(long)listItem.currentPosition];
    cell.prevPosVal.text = [NSString stringWithFormat:@"%ld",(long)listItem.prevousPosition];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark -

@end
