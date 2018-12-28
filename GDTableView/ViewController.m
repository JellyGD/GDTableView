//
//  ViewController.m
//  GDTableView
//
//  Created by jelly on 2018/12/27.
//  Copyright © 2018 jelly. All rights reserved.
//

#import "ViewController.h"


static NSString *const kGDCellIdentifier = @"kGDCellIdentifier";


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self loadData];
}


#pragma mark - Data

- (void)loadData{
    self.tableViewArray = @[UIColor.redColor,UIColor.yellowColor,UIColor.greenColor,UIColor.cyanColor,UIColor.redColor,UIColor.yellowColor,UIColor.greenColor,UIColor.cyanColor];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
    return 300.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGDCellIdentifier];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIColor *color = [self.tableViewArray objectAtIndex:indexPath.row];
    cell.backgroundColor = color;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
}

#pragma mark - Getter && Setter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGDCellIdentifier];
        
    }
    return _tableView;
}

- (NSMutableArray *)tableViewArray{
    if (!_tableViewArray) {
        _tableViewArray = [NSMutableArray array];
    }
    return _tableViewArray;
}




@end
