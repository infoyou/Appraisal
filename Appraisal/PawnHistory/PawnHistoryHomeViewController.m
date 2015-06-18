
#import "PawnHistoryHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"
#import "PawnReportViewController.h"

@interface PawnHistoryHomeViewController () 

@property (nonatomic, retain) NSMutableDictionary *imageArray;

@end

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

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
    
    // add additional scroll area arround content
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        const CGRect navBarFrame = self.navigationController.navigationBar.frame;
        const CGFloat blankVerticalSpace = navBarFrame.origin.y + navBarFrame.size.height;
        mTableView.contentInset = UIEdgeInsetsMake(blankVerticalSpace, 0, 0, 0);
    }
}

- (void)adjustView
{

    mTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
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
    
    UILabel *title = (UILabel *)[cell viewWithTag:100];
    UILabel *title1 = (UILabel *)[cell viewWithTag:101];
    UILabel *title2 = (UILabel *)[cell viewWithTag:102];
    UILabel *title3 = (UILabel *)[cell viewWithTag:103];
    
    NSInteger row = [indexPath row];
    AssessObject *assessObject = (AssessObject *)recordArray[row];
    
    title.text = [NSString stringWithFormat:@"%@", assessObject.mark1];
    title1.text = [NSString stringWithFormat:@"%@", assessObject.mark2];
    title2.text = [NSString stringWithFormat:@"%@", assessObject.mark3];
    title3.text = [NSString stringWithFormat:@"%@", assessObject.mark4];
    
    if ([assessObject.fileName length] > 0)
    {
        NSString *localFileName = [assessObject.fileName componentsSeparatedByString:@"$"][0];
        
        UIImage *userImage = [imageArray objectForKey:[NSNumber numberWithInt:row]];
        if (userImage) { // if the dictionary of images has it just display it
            UIImageView *updateIconView = (UIImageView *)[cell viewWithTag:99];
            updateIconView.image = userImage;
        } else {
            
            // cell.imageView.image = [UIImage imageNamed:@"Icon.png"]; // set placeholder image
            NSString *filePath = [CommonUtils loadImagePath:@"/image" file:localFileName];
            
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
                        UIImage *tempImage = [UIImage imageWithData:imageData];
                        
                        UIImage *image = [CommonUtils imageScaleToSize:tempImage size:CGSizeMake(86, 91)];
                        
                        [self.imageArray setObject:image forKey:[NSNumber numberWithInt:row]];
                        
                        UITableViewCell *lookedUpCell = [tableView cellForRowAtIndexPath:indexPath];
                        UIImageView *updateIconView = (UIImageView *)[lookedUpCell viewWithTag:99];
                        
                        if (lookedUpCell){
                            updateIconView.image = image;
                            [lookedUpCell setNeedsLayout];
                        }
                    });
                }
            });
        }
    } else {
        // 默认图片
        UIImageView *iconView = (UIImageView *)[cell viewWithTag:99];
        
        switch (assessObject.logicType) {
            case 1:// 房地产
                iconView.image = [UIImage imageNamed:@"houseIcon.png"];
                break;
                
            case 2:// 汽车
                iconView.image = [UIImage imageNamed:@"carIcon.png"];
                break;
                
            case 3:// 钻石
                iconView.image = [UIImage imageNamed:@"demandIcon.png"];
                break;
                
            case 4:// 手表
                iconView.image = [UIImage imageNamed:@"watchIcon.png"];
                break;
                
            case 5:// 素金
                iconView.image = [UIImage imageNamed:@"goldIcon.png"];
                break;
                
            case 6:// 有色宝石
                iconView.image = [UIImage imageNamed:@"metalIcon.png"];
                break;
                
            case 7:// 玉石饰品
                iconView.image = [UIImage imageNamed:@"stoneIcon.png"];
                break;
                
            case 8:// 艺术品
                iconView.image = [UIImage imageNamed:@"artIcon.png"];
                break;
                
            default:
                break;
        }
    }
    
//    cell.backgroundColor = HEX_COLOR(VIEW_BG_COLOR);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];
    AssessObject *assessObject = (AssessObject *)recordArray[row];
    [AppManager instance].objectRecordId = assessObject.assessId;
    
    PawnReportViewController *reportVC = [[PawnReportViewController alloc] init];
    [self pushViewController:reportVC];

}

@end
