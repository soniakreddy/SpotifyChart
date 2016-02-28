//
//  Track.h
//  SpotifyChart
//
//  Created by Sonia Reddy Kolli on 02/26/16.
//  Copyright (c) 2016 Sonia Reddy Kolli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property(nonatomic,strong) NSString *albumId;
@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,strong) NSString *trackDetailsUrl;
@property(nonatomic,strong) NSString *previewUrl;
@property(nonatomic,strong) NSString *name;
@property(nonatomic) NSInteger currentPosition;
@property(nonatomic) NSInteger prevousPosition;
@property(nonatomic) double playCount;
@property(nonatomic) double duration;
@property(nonatomic,strong) NSMutableArray *artists;

@end
