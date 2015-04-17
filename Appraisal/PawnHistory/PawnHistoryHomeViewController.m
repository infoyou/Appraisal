
#import "PawnHistoryHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"
#import "PawnReportViewController.h"

@interface PawnHistoryHomeViewController () 

@property (nonatomic, retain) NSMutableDictionary *imageArray;

@end

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define kBgQueue dispatch_queue_create("com.company.app.imageQueue", NULL)

@implementation PawnHistoryHomeViewController
{
    
    NSMutableArray *recordArray;
}

@synthesize mTableView;
@synthesize imageArray;

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
    
    imageArray = [NSMutableDictionary dictionary];
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
//    listIconView.image = [UIImage imageNamed:@"icon.png"];
    
    /*
    UIImage *userImage = [imageArray objectForKey:[NSNumber numberWithInt:row]];
    if (userImage) { // if the dictionary of images has it just display it
        cell.imageView.image = userImage;
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"icon.png"]; // set placeholder image
        NSString *filePath = [CommonUtils loadImagePath:@"/image" file:assessObject.fileName];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = nil;
            if (fileExists){
                imageData = [NSData dataWithContentsOfFile:filePath];
            }
            
            if (imageData){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UIKit, which includes UIImage warns about not being thread safe
                    // So we switch to main thread to instantiate image
                    UIImage *image = [UIImage imageWithData:imageData];
                    [self.imageArray setObject:image forKey:[NSNumber numberWithInt:row]];
                    
                    UITableViewCell *lookedUpCell = [tableView cellForRowAtIndexPath:indexPath];
                    UIImageView *iconView = (UIImageView *)[lookedUpCell viewWithTag:99];
                    
                    if (lookedUpCell){
                        iconView.image = image;
                        [lookedUpCell setNeedsLayout];
                    }
                }); 
            }
        });
    }
    */
    
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
