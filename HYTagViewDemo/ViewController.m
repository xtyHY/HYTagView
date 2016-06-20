//
//  ViewController.m
//  HYTagViewDemo
//
//  Created by 徐天宇 on 16/6/20.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import "ViewController.h"
#import "HYTagView.h"

@interface ViewController (){
    
    HYTagView *_tagView;
}

@end

@implementation ViewController

- (IBAction)selectAll:(id)sender {
    
    [_tagView selectAllTag];
}

- (IBAction)deSelectAll:(id)sender {
    
    [_tagView unselectAllTag];
}

- (IBAction)getAllSelected:(id)sender {

    NSLog(@"%@",[_tagView getSelectedTags]);
}


- (IBAction)getAllUNSelected:(id)sender {
    
    NSLog(@"%@",[_tagView getUnselectedTags]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                        @{@"tagId":@100, @"tagName":@"test1", @"isSelected":@NO},
                        @{@"tagId":@102, @"tagName":@"te2323", @"isSelected":@NO},
                        @{@"tagId":@103, @"tagName":@"t123123123123", @"isSelected":@NO},
                        @{@"tagId":@105, @"tagName":@"tesdfdsfds", @"isSelected":@NO},
                        @{@"tagId":@106, @"tagName":@"test1", @"isSelected":@YES},
                        @{@"tagId":@107, @"tagName":@"test213", @"isSelected":@NO},
                        @{@"tagId":@101, @"tagName":@"test12312314", @"isSelected":@NO}
                       ];
    
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array) {
        
        [marray addObject:[[HYTagModel alloc] initWithDict:dict]];
    }
    
    _tagView = [[HYTagView alloc] initWithFrame:(CGRect){0,50,[UIScreen mainScreen].bounds.size.width, 0} tagsArray:marray];
    _tagView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_tagView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
