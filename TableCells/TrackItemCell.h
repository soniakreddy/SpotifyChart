//
//  TrackItemCell.h
//  SpotifyChart
//
//  Created by Sonia Reddy Kolli on 02/26/16.
//  Copyright (c) 2016 Sonia Reddy Kolli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackItemCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *nameVal;
@property(nonatomic,strong) IBOutlet UILabel *currPosVal;
@property(nonatomic,strong) IBOutlet UILabel *prevPosVal;

@end
