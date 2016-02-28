//
//  TrackDetailsViewController.m
//  SpotifyChart
//
//  Created by Sonia Reddy Kolli on 02/26/16.
//  Copyright (c) 2016 Sonia Reddy Kolli. All rights reserved.
//

#import "TrackDetailsViewController.h"
#import "Track.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface TrackDetailsViewController()<AVAudioPlayerDelegate>{
    
    IBOutlet UITableView *artists;
    IBOutlet UIImageView *previewImage;
    IBOutlet UILabel *name;
    IBOutlet UILabel *currentPosition;
    IBOutlet UILabel *prevousPosition;
    IBOutlet UILabel *playCount;
    IBOutlet UILabel *duration;    
    AVAudioPlayer *audioPlayer;
    BOOL isPlayProgress;
}

@end

@implementation TrackDetailsViewController
@synthesize selectedTrack;

-(void)viewDidLoad{
    
    UIImage *tempImg = [self getImageFromURL:selectedTrack.imageUrl];
    previewImage.image = tempImg;

    name.text = selectedTrack.name;
    NSString *currentPositionString = [NSString stringWithFormat:@"%ld", (long)selectedTrack.currentPosition];
    NSString *previousPositionString = [NSString stringWithFormat:@"%ld", (long)selectedTrack.prevousPosition];
    NSString *playCountString = [NSString stringWithFormat:@"%ld", (long)selectedTrack.playCount];
    currentPosition.text = currentPositionString;
    prevousPosition.text = previousPositionString;
    playCount.text = playCountString;
    duration.text = [self formatInterval:(selectedTrack.duration)];
    [artists reloadData];
}

- (NSString *) formatInterval: (NSTimeInterval) interval{
    unsigned long milliseconds = interval;
    unsigned long seconds = milliseconds / 1000;
    milliseconds %= 1000;
    unsigned long minutes = seconds / 60;
    seconds %= 60;
    unsigned long hours = minutes / 60;
    minutes %= 60;
    
    NSMutableString * result = [NSMutableString new];
    
    if(hours)
        [result appendFormat: @"%lu:", hours];
    
    [result appendFormat: @"%2lu:", minutes];
    [result appendFormat: @"%2lu", seconds];
//    [result appendFormat: @"%1lu",milliseconds];
    
    return result;
}
-(UIImage*) getImageFromURL:(NSString *)fileURL {
    UIImage *result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(IBAction)preview:(id)sender{
    
    UIButton *playPauseBt = (UIButton*)sender;
    
    NSURL *url = [NSURL URLWithString:selectedTrack.previewUrl];
    NSData *soundData = [NSData dataWithContentsOfURL:url];
    audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData  error:NULL];
    audioPlayer.delegate = self;
    [audioPlayer play];
    if (isPlayProgress ) {
        //change the button here to play again
        [audioPlayer stop];
        audioPlayer=nil;
        isPlayProgress = NO;
    }
    else{
        //change the button to pause
        isPlayProgress = YES;
        
    }
    playPauseBt.selected = isPlayProgress;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [audioPlayer stop];
    NSLog(@"Finished Playing");
    isPlayProgress = NO;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
    isPlayProgress = NO;
}

#pragma mark -
#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return selectedTrack.artists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *artistTableCell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
    artistTableCell.textLabel.text = [selectedTrack.artists objectAtIndex:indexPath.row];
    return artistTableCell;
}


@end
