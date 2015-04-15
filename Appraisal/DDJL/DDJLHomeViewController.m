
#import "DDJLHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"

@interface DDJLHomeViewController () 

@end

@implementation DDJLHomeViewController
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
    return 5;
}

#pragma mark - tableview的cell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DDJLListCell" owner:self options:nil] lastObject];
    
    UIView *bgView = (UIView *)[cell viewWithTag:9];
    
    UIImageView *iconView = (UIImageView *)[cell viewWithTag:10];
    
    UILabel *name = (UILabel *)[cell viewWithTag:11];
    UILabel *desc = (UILabel *)[cell viewWithTag:12];
    UILabel *memberPrice = (UILabel *)[cell viewWithTag:13];
    UILabel *price = (UILabel *)[cell viewWithTag:14];
    UILabel *userCount = (UILabel *)[cell viewWithTag:15];
    
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
    
}

@end
