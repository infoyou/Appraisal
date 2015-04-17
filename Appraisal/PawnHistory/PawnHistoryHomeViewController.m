
#import "PawnHistoryHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"
#import "PawnReportViewController.h"

@interface PawnHistoryHomeViewController () 

@end

@implementation PawnHistoryHomeViewController
{
    
    NSMutableArray *recordArray;
}

@synthesize mTableView;

#pragma mark - UIViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    recordArray = [[FMDBConnection instance] getAssessRecordArrayByLogicType:PAWN_LOGIC_TYPE];
    
    if ([recordArray count] > 0) {
        self.promptLabel.hidden = YES;
    } else {
        self.promptLabel.hidden = NO;
    }
}

- (void)adjustView
{

    mTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    
    NSLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);
    
    mTableView.backgroundColor = [UIColor clearColor];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark tableview每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

#pragma mark 返回tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recordArray count];
}

#pragma mark - tableview的cell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PawnHistoryListCell" owner:self options:nil] lastObject];
    
    UIImageView *listIconView = (UIImageView *)[cell viewWithTag:99];
    
    UILabel *title = (UILabel *)[cell viewWithTag:100];
    UILabel *desc = (UILabel *)[cell viewWithTag:101];

    NSInteger row = [indexPath row];
    AssessObject *assessObject = (AssessObject *)recordArray[row];
    
    title.text = [NSString stringWithFormat:@"%@ %@", assessObject.mark1, assessObject.mark2];
    desc.text = [NSString stringWithFormat:@"%@ %@", assessObject.mark3, assessObject.mark4];
    
    UIImage *localImage = [CommonUtils loadImageFromDocument:@"/image" file:assessObject.fileName];
    listIconView.image = localImage;
    
    listIconView.image = [UIImage imageNamed:@"icon.png"];
    /*
    NSString *imageUrl = [backDataArr[indexPath.row] valueForKey:@"thumbnail_url"];
     
    [iconView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:imageUrl] andPlaceholderImage:[UIImage imageNamed:@"placehold.png"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //Nothing.
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //Nothing.
    }];
    */
    
//    bgView.layer.cornerRadius = 4;
//    bgView.layer.masksToBounds = YES;
    
//    cell.backgroundColor = HEX_COLOR(VIEW_BG_COLOR);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ProductDetailViewController *productVC = [[ProductDetailViewController alloc] init];
//    productVC.productId = [backDataArr[indexPath.row] valueForKey:@"product_id"];;
//    self.navigationController.visibleViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"团购" style:0 target:nil action:nil];
//    [self.navigationController pushViewController:productVC animated:YES];
    
    NSInteger row = [indexPath row];
    AssessObject *assessObject = (AssessObject *)recordArray[row];
    [AppManager instance].objectRecordId = assessObject.assessId;
    
    PawnReportViewController *reportVC = [[PawnReportViewController alloc] init];
    
    //    [self.navigationController pushViewController:reportVC animated:YES];
    [self presentViewController:reportVC animated:YES completion:^{}];

}

@end
