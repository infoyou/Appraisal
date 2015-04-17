
#import "AssessHistoryHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"
#import "ReportViewController.h"
#import "AssessObject.h"

@interface AssessHistoryHomeViewController () 

@end

@implementation AssessHistoryHomeViewController
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

    recordArray = [[FMDBConnection instance] getAssessRecordArrayByLogicType:ASSESS_LOGIC_TYPE];
    
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
    
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AssessHistoryListCell" owner:self options:nil] lastObject];
    
    UIImageView *listIconView = (UIImageView *)[cell viewWithTag:99];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *marketPrice = (UILabel *)[cell viewWithTag:101];
    UILabel *usedPrice = (UILabel *)[cell viewWithTag:102];
    UILabel *pawnPrice = (UILabel *)[cell viewWithTag:103];
    
    NSInteger row = [indexPath row];
    AssessObject *assessObject = (AssessObject *)recordArray[row];
    
    titleLabel.text = [NSString stringWithFormat:@"%@ %@", assessObject.mark1, assessObject.mark2];
    marketPrice.text = assessObject.marketPrice;
    usedPrice.text = assessObject.usedPrice;
    pawnPrice.text = assessObject.pawnPrice;
    
    // Object Image
//    UIImage *localImage = [CommonUtils loadImageFromDocument:@"/image" file:assessObject.fileName];
    
    switch (assessObject.logicType) {
        case 1:// 房地产
            listIconView.image = [UIImage imageNamed:@"houseIcon.png"];
            break;
            
        case 2:// 汽车
            listIconView.image = [UIImage imageNamed:@"carIcon.png"];
            break;
            
        case 3:// 钻石
            listIconView.image = [UIImage imageNamed:@"demandIcon.png"];
            break;
            
        case 4:// 手表
            listIconView.image = [UIImage imageNamed:@"watchIcon.png"];
            break;
            
        case 5:// 素金
            listIconView.image = [UIImage imageNamed:@"goldIcon.png"];
            break;
            
        case 6:// 有色宝石
            listIconView.image = [UIImage imageNamed:@"metalIcon.png"];
            break;
            
        case 7:// 玉石饰品
            listIconView.image = [UIImage imageNamed:@"stoneIcon.png"];
            break;
            
        case 8:// 艺术品
            listIconView.image = [UIImage imageNamed:@"artIcon.png"];
            break;
            
        default:
            break;
    }

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
    
//    [self goReport:[NSDictionary dictionary]];
}

@end
