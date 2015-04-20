
#import "RightMenuViewController.h"

#import "UIWebViewController.h"
#import "CommonUtils.h"

#import "PawnHistoryHomeViewController.h"
#import "AssessHistoryHomeViewController.h"
#import "AboutViewController.h"

@interface RightMenuViewController ()

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;

@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
@property (nonatomic, strong) NSDictionary *paneViewControllerAppearanceTypes;
@property (nonatomic, strong) NSDictionary *sectionTitles;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealRightBarButtonItem;

@end

@implementation RightMenuViewController
{
    
    NSInteger selIndex;
    NSArray *menuIconArray;
    NSArray *menuIconSelArray;
}

#pragma mark - NSObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selIndex = -1;
    
    menuIconArray = @[@"jrdd.png", @"jdpg.png", @"hsgy.png"];
    menuIconSelArray = @[@"jrdd_sel.png", @"jdpg_sel.png", @"hsgy_sel.png"];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - RightMenuViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles = @{
                                      @(DDJLVC) : @"典当记录",
                                      @(JDPGJLVC) : @"鉴定评估记录",
                                      @(AboutVC) : @"关于我们"
                                      };
    
    self.paneViewControllerClasses = @{
                                       @(DDJLVC) : [PawnHistoryHomeViewController class],
                                       @(JDPGJLVC) : [AssessHistoryHomeViewController class],
                                       @(AboutVC) : [AboutViewController class]
                                       };

}

- (MSPaneRightViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    MSPaneRightViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {
        paneViewControllerType = indexPath.row;
    } else {
//        paneViewControllerType = ([self.tableViewSectionBreaks[(indexPath.section - 1)] integerValue] + indexPath.row);
    }
    
    NSAssert(paneViewControllerType < MSLeftPaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (void)transitionToViewController:(MSPaneRightViewControllerType)paneViewControllerType
{
    /*
    // Close pane if already displaying that pane view controller
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
        return;
    }
    */
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil;
    
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    UIViewController *paneViewController = (UIViewController *)[paneViewControllerClass new];
    
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    // Left
    UIButton *leftBut =  [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBut setImage:[UIImage imageNamed:@"type.png"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)forControlEvents:UIControlEventTouchUpInside];
    [leftBut setFrame:CGRectMake(0, 0, 17, 13)];
    
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    paneViewController.navigationItem.leftBarButtonItem = leftBarBtnItem;
    
    // Right
    UIButton *rightBut =  [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut setImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(dynamicsDrawerRevealRightBarButtonItemTapped:)forControlEvents:UIControlEventTouchUpInside];
    [rightBut setFrame:CGRectMake(0, 0, 18, 18)];
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    paneViewController.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    // 修饰 NavigationViewController
    [paneNavigationViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBg.png"] forBarMetrics:UIBarMetricsDefault];
    [paneNavigationViewController.navigationBar setBarStyle:UIBarStyleBlack];
    
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
}

- (void)dynamicsDrawerRevealRightBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionRight animated:YES allowUserInterruption:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
    view.backgroundColor = [UIColor clearColor];
    
    UITableViewCell *rightMenuHeadCell = [[[NSBundle mainBundle] loadNibNamed:@"RightMenuHeadCell" owner:self options:nil] lastObject];
    rightMenuHeadCell.backgroundColor = [CommonUtils colorWithHexString:@"0a1425"];
    rightMenuHeadCell.frame = CGRectMake(0, 66, 320, 50);
    [view addSubview:rightMenuHeadCell];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new]; // Hacky way to prevent extra dividers after the end of the table from showing
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66+50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN; // Hacky way to prevent extra dividers after the end of the table from showing
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RightContentTypeCell" owner:self options:nil] lastObject];
    
    UIImageView *iconView = (UIImageView *)[cell viewWithTag:10];
    UILabel *typeName = (UILabel*)[cell viewWithTag:11];
    
    typeName.text = self.paneViewControllerTitles[@([self paneViewControllerTypeForIndexPath:indexPath])];
    
    NSInteger row = [indexPath row];
    if (row == selIndex) {
        
        iconView.image = [UIImage imageNamed:menuIconSelArray[row]];
        typeName.textColor = [CommonUtils colorWithHexString:@"3d98ff"];
        cell.backgroundColor = [CommonUtils colorWithHexString:@"0a1425"];
    } else {
        
        iconView.image = [UIImage imageNamed:menuIconArray[row]];
        typeName.textColor = [CommonUtils colorWithHexString:@"ffffff"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (row == 2) {
        iconView.frame = CGRectMake(107, 12, 20, 25);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    selIndex = row;
    
    // 样式修改
    UITableViewCell * selCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *iconView = (UIImageView *)[selCell viewWithTag:10];
    UILabel *typeName = (UILabel*)[selCell viewWithTag:11];
    
    iconView.image = [UIImage imageNamed:menuIconSelArray[row]];
    typeName.textColor = [CommonUtils colorWithHexString:@"3d98ff"];
    selCell.backgroundColor = [CommonUtils colorWithHexString:@"0a1425"];
    
    // 页面切换
    MSPaneRightViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    [self transitionToViewController:paneViewControllerType];
    
    // Prevent visual display bug with cell dividers
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
    
    // 取消Left选中状态
    [(AppDelegate *)APP_DELEGATE resetLeftMenuState];
    
    /*
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
     */
}

#pragma mark - MSDynamicsDrawerViewControllerDelegate

- (void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)dynamicsDrawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)state
{
    // Ensure that the pane's table view can scroll to top correctly
    self.tableView.scrollsToTop = (state == MSDynamicsDrawerPaneStateOpen);
}

- (void)updateCellStateToNormal
{
    if (selIndex < 0) {
        return;
    }
    
    NSIndexPath *selIndexPath = [NSIndexPath indexPathForRow:selIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selIndexPath];
    
    UIImageView *iconView = (UIImageView *)[cell viewWithTag:10];
    UILabel *typeName = (UILabel*)[cell viewWithTag:11];
    
    iconView.image = [UIImage imageNamed:menuIconArray[selIndex]];
    typeName.textColor = [CommonUtils colorWithHexString:@"ffffff"];
    cell.backgroundColor = [UIColor clearColor];
    
    if (selIndex == 2) {
        iconView.frame = CGRectMake(107, 12, 20, 25);
    }

}

@end
