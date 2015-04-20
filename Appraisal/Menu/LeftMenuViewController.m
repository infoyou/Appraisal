
#import "LeftMenuViewController.h"

#import "AssessHomeViewController.h"
#import "PawnHomeViewController.h"

#import "UIWebViewController.h"
#import "CommonUtils.h"

@interface LeftMenuViewController ()

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
@property (nonatomic, strong) NSDictionary *paneViewControllerAppearanceTypes;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealRightBarButtonItem;

@end

@implementation LeftMenuViewController
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
    
//    selIndex = -1;
    
    menuIconArray = @[@"jdpg.png", @"jrdd.png", @"hsgy.png", @"dfddlm.png", @"ddsc.png"];
    menuIconSelArray = @[@"jdpg_sel.png", @"jrdd_sel.png", @"hsgy_sel.png", @"dfddlm_sel.png", @"ddsc_sel.png"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - LeftMenuViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    
    self.paneViewControllerTitles = @{
        @(JDPGVC) : @"鉴定评估",
        @(JRDDVC) : @"金融典当",
        @(UIWebVC) : @"海上谷韵",
        @(UIWebVC1) : @"东方典当联盟",
        @(UIWebVC2) : @"典当商城"
    };

    self.paneViewControllerClasses = @{
        @(JDPGVC) : [AssessHomeViewController class],
        @(JRDDVC) : [PawnHomeViewController class],
        @(UIWebVC) : [UIWebViewController class],
        @(UIWebVC1) : [UIWebViewController class],
        @(UIWebVC2) : [UIWebViewController class]
    };
    
}

- (MSPaneLeftViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    MSPaneLeftViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {
        paneViewControllerType = indexPath.row;
    } else {
//        paneViewControllerType = ([self.tableViewSectionBreaks[(indexPath.section - 1)] integerValue] + indexPath.row);
    }
    NSAssert(paneViewControllerType < MSPaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (void)transitionToViewController:(MSPaneLeftViewControllerType)paneViewControllerType
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
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new]; // Hacky way to prevent extra dividers after the end of the table from showing
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66;
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
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"LeftContentTypeCell" owner:self options:nil] lastObject];
    
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
        iconView.frame = CGRectMake(40, 12, 20, 25);
    } else if (row == 3) {
        iconView.frame = CGRectMake(35, 15, 29, 20);
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
    
    switch (selIndex) {
            
        case UIWebVC:
        {
            [AppManager instance].webUrl = @"http://wx.orientalpawn.com/mpawn/hsgy.html";
        }
            break;
            
        case UIWebVC1:
        {
            [AppManager instance].webUrl = @"http://wx.orientalpawn.com/mpawn/ddlm.html";
        }
            break;
            
        case UIWebVC2:
        {
            [AppManager instance].webUrl = @"http://wx.orientalpawn.com/mpawn/products.html";
        }
            break;
            
        default:
            break;
    }
    
    // 页面切换
    MSPaneLeftViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    [self transitionToViewController:paneViewControllerType];
    
    // Prevent visual display bug with cell dividers
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
    
    // 取消Right选中状态
    [(AppDelegate *)APP_DELEGATE resetRightMenuState];
    
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
        iconView.frame = CGRectMake(40, 12, 20, 25);
    } else if (selIndex == 3) {
        iconView.frame = CGRectMake(35, 15, 29, 20);
    }
    
}

@end
