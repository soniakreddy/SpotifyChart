//
//  TrackDetailsViewController.h
//  SpotifyChart
//
//  Created by Sonia Reddy Kolli on 02/26/16.
//  Copyright (c) 2016 Sonia Reddy Kolli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Track;
@interface TrackDetailsViewController : UIViewController

@property(nonatomic,strong) Track *selectedTrack;

@end
