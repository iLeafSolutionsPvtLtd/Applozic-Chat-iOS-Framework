//
//  StickerTableCell.m
//  Applozic
//
//  Created by Levin  on 24/04/18.
//

#import "StickerTableCell.h"
#import "ALUtilityClass.h"
#import "ALConstant.h"

#define MT_INBOX_CONSTANT "4"


@implementation StickerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateStickerCell:(ALMessage*)message{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    if ([message.type isEqualToString:@MT_INBOX_CONSTANT]){
        [self.ImageViewLeft setHidden:false];
        [self.ImageViewRight setHidden:true];
        [self.lblDateRight setHidden:true];
        [self.chatReadRight setHidden:true];
        NSBundle * bundle =  [NSBundle bundleWithIdentifier:@"org.cocoapods.Applozic"];
        
        UIImage * image = [UIImage imageNamed:message.metadata[@"sticker"] inBundle:bundle compatibleWithTraitCollection:nil];
        self.ImageViewLeft.image = image;
        
    }else{
        [self.ImageViewLeft setHidden:true];
        [self.ImageViewRight setHidden:false];
        [self.lblDateRight setHidden:false];
        [self.chatReadRight setHidden:false];
        NSBundle * bundle = [NSBundle bundleWithIdentifier:@"org.cocoapods.Applozic"];
        UIImage * image =  [UIImage imageNamed:message.metadata[@"sticker"] inBundle:bundle compatibleWithTraitCollection:nil];

        //UIImage * image = [UIImage imageNamed:message.userKey inBundle:bundle compatibleWithTraitCollection:nil];
        
        self.ImageViewRight.image = image;
        if (![message.type isEqualToString:@MT_INBOX_CONSTANT] && (message.contentType != ALMESSAGE_CHANNEL_NOTIFICATION)) {
            
            //self.mMessageStatusImageView.hidden = NO;
            NSString * imageName;
            
            switch (message.status.intValue) {
                case DELIVERED_AND_READ :{
                    imageName = @"ic_action_read.png";
                }break;
                case DELIVERED:{
                    imageName = @"ic_action_message_delivered.png";
                }break;
                case SENT:{
                    imageName = @"ic_action_message_sent.png";
                }break;
                default:{
                    imageName = @"ic_action_about.png";
                }break;
            }
            self.chatReadRight.image = [ALUtilityClass getImageFromFramworkBundle:imageName];
            BOOL today = [[NSCalendar currentCalendar] isDateInToday:[NSDate dateWithTimeIntervalSince1970:[message.createdAtTime doubleValue]/1000]];
            NSString * theDate = [NSString stringWithFormat:@"%@",[message getCreatedAtTimeChat:today]];
            self.lblDateRight.text = theDate;
        }
    }
    
}

@end
