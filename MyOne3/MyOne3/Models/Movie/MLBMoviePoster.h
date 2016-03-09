//
//  MLBMoviePoster.h
//  MyOne3
//
//  Created by meilbn on 3/8/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NYTPhotoViewer/NYTPhoto.h>

@interface MLBMoviePoster : NSObject <NYTPhoto>

@property (nonatomic) UIImage *image;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;

@end
