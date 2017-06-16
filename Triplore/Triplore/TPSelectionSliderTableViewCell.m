//
//  TPSelectionSliderTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/14.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSelectionSliderTableViewCell.h"
#import "SDCycleScrollView.h"
#import "TPCategoryButton.h"
#import "TPVideoModel.h"

@interface TPSelectionSliderTableViewCell () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet TPCategoryButton *foodButton;
@property (weak, nonatomic) IBOutlet TPCategoryButton *shoppingButton;
@property (weak, nonatomic) IBOutlet TPCategoryButton *placeButton;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation TPSelectionSliderTableViewCell


static NSInteger const width = 480;
static NSInteger const height = 270;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // buttons
    NSArray *buttons = @[self.foodButton, self.shoppingButton, self.placeButton];
    
    NSInteger start = 11;
    for (UIButton *button in buttons) {
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = start;
        [button addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        start ++;
    }

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
//    
   
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageNamesGroup:@[@"TEST_PNG", @"TEST_PNG", @"TEST_PNG"]];
    
//    TestView *view = [[TestView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
//    [self addSubview:view];
//    
}

- (void)setVideos:(NSArray<TPVideoModel *> *)videos {
    _videos = videos;
    
    NSArray *images = [[NSArray alloc] init];
    NSArray *titles = [[NSArray alloc] init];
    
    for (TPVideoModel *video in videos) {
        NSString *url = [video.imgURL stringByReplacingOccurrencesOfString:@".jpg" withString:[NSString stringWithFormat:@"_%d_%d.jpg", width, height]];
        titles = [titles arrayByAddingObject:video.shortTitle];
        images = [images arrayByAddingObject:url];
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGRect frame = CGRectMake(0, 0, width, width / 7 * 3);
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"TEST_PNG"]];
    [self addSubview:self.cycleScrollView];
    self.cycleScrollView.imageURLStringsGroup = images;
    self.cycleScrollView.titlesGroup = titles;

}

- (void)clickCategoryButton:(UIButton *)button {
    if([self.delegate respondsToSelector:@selector(didTapCategory:)]) {
        [self.delegate didTapCategory:button.tag - 10];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
