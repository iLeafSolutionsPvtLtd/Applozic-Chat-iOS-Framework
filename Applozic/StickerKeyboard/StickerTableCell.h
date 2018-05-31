//
//  StickerTableCell.h
//  Applozic
//
//  Created by Levin  on 24/04/18.
//

#import <UIKit/UIKit.h>
#import "ALMessage.h"

@interface StickerTableCell : UITableViewCell
@property (nonatomic,retain) UIImageView * mUserProfileImageView;
@property (retain, nonatomic) UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewRight;
@property (weak, nonatomic) IBOutlet UILabel *lblDateRight;
@property (weak, nonatomic) IBOutlet UIImageView *chatReadRight;

-(void)populateStickerCell:(ALMessage*)message;

@end
