//
//  MLBPreviousViewController.m
//  MyOne3
//
//  Created by meilbn on 4/18/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBPreviousViewController.h"
#import "DZNSegmentedControl.h"
#import "MLBHomePreviousViewController.h"
#import "MLBMusicPreviousViewController.h"
#import "MLBReadPreviousViewController.h"

@interface MLBPreviousViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

NSString *const kPreviousCellID = @"MLBPreviousCellID";

@implementation MLBPreviousViewController {
    NSMutableArray *dataSource;
    MLBReadType readType;
    NSString *currentPeriod;
}

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"往期列表";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self initDatas];
    [self setupViews];
    [self configureDataSource];
}

#pragma mark - Private Method

- (void)initDatas {
    readType = MLBReadTypeEssay;
    dataSource = [NSMutableArray arrayWithCapacity:30];
}

- (void)setupViews {
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorColor = MLBSeparatorColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kPreviousCellID];
        tableView.tableFooterView = [UIView new];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
    
    if (_previousType == MLBPreviousTypeRead) {
        DZNSegmentedControl *segmentedControl = [[DZNSegmentedControl alloc] initWithItems:@[@"短篇", @"连载", @"问题"]];
        segmentedControl.backgroundColor = [UIColor whiteColor];
        segmentedControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        segmentedControl.showsCount = NO;
        segmentedControl.font = FontWithSize(12);
        [segmentedControl setTitleColor:[UIColor colorWithWhite:127 / 255.0 alpha:1] forState:UIControlStateNormal];
        segmentedControl.tintColor = MLBAppThemeColor;
        segmentedControl.hairlineColor = nil;
        [segmentedControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
        _tableView.tableHeaderView = segmentedControl;
    }
}

- (void)configureDataSource {
    NSInteger earliestDateUnitYear = 0;
    NSInteger earliestDateUnitMonth = 0;
    
    if (_previousType == MLBPreviousTypeHome || (_previousType == MLBPreviousTypeRead && (readType == MLBReadTypeEssay || readType == MLBReadTypeQuestion))) {
        earliestDateUnitYear = 2012;
        earliestDateUnitMonth = 10;
    } else if (_previousType == MLBPreviousTypeMusic || (_previousType == MLBPreviousTypeRead && (readType == MLBReadTypeSerial))) {
        earliestDateUnitYear = 2016;
        earliestDateUnitMonth = 01;
    }
    
    if (earliestDateUnitYear == 0 || earliestDateUnitMonth == 0) {
        return;
    }
    
    [dataSource removeAllObjects];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
    NSInteger nowUnitYear = [components valueForComponent:NSCalendarUnitYear];
    NSInteger nowUnitMonth = [components valueForComponent:NSCalendarUnitMonth];
    
    NSInteger monthForLoop = earliestDateUnitMonth;
    
    for (NSInteger startYear = earliestDateUnitYear; startYear <= nowUnitYear; startYear++) {
        for (NSInteger startMonth = monthForLoop; startMonth <= 12; startMonth++) {
            if (startYear == nowUnitYear && startMonth == nowUnitMonth) {
                [dataSource insertObject:@"本月" atIndex:0];
                currentPeriod = [NSString stringWithFormat:@"%ld-%02ld", startYear, startMonth];
                break;
            }
            
            [dataSource insertObject:[NSString stringWithFormat:@"%ld-%02ld", startYear, startMonth] atIndex:0];
        }
        
        monthForLoop = 01;
    }
    
    [_tableView reloadData];
}

#pragma mark - Public Method



#pragma mark - Action

- (void)selectedSegment:(DZNSegmentedControl *)control {
    if (control.selectedSegmentIndex == 0) {
        readType = MLBReadTypeEssay;
    } else if (control.selectedSegmentIndex == 1) {
        readType = MLBReadTypeSerial;
    } else if (control.selectedSegmentIndex == 2) {
        readType = MLBReadTypeQuestion;
    }
    
    [self configureDataSource];
}

#pragma mark - Network Request



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:kPreviousCellID forIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IsStringEmpty(cell.textLabel.text)) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];
        cell.textLabel.font = FontWithSize(16);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = dataSource[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectedPeriod = @"";
    if (indexPath.row == 0) {
        selectedPeriod = currentPeriod;
    } else {
        selectedPeriod = dataSource[indexPath.row];
    }
    
    switch (_previousType) {
        case MLBPreviousTypeHome: {
            MLBHomePreviousViewController *homePreviousViewController = [[MLBHomePreviousViewController alloc] init];
            homePreviousViewController.period = selectedPeriod;
            [self.navigationController pushViewController:homePreviousViewController animated:YES];
            break;
        }
        case MLBPreviousTypeRead: {
            MLBReadPreviousViewController *readPreviousViewController = [[MLBReadPreviousViewController alloc] init];
            readPreviousViewController.readType = readType;
            readPreviousViewController.period = selectedPeriod;
            [self.navigationController pushViewController:readPreviousViewController animated:YES];
            break;
        }
        case MLBPreviousTypeMusic: {
            MLBMusicPreviousViewController *musicPreviousViewController = [[MLBMusicPreviousViewController alloc] init];
            musicPreviousViewController.period = selectedPeriod;
            [self.navigationController pushViewController:musicPreviousViewController animated:YES];
            break;
        }
    }
}

@end
