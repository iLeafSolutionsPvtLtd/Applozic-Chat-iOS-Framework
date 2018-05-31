//
//  StickerTableCell.m
//  Applozic
//
//  Created by Levin  on 24/04/18.
//

#import "StickerTableCell.h"
#import "ALUtilityClass.h"
#import "ALConstant.h"
#import "ALColorUtility.h"
#import "ALContactDBService.h"
#import "UIImageView+WebCache.h"

#define MT_INBOX_CONSTANT "4"
#define USER_PROFILE_PADDING_X 5
#define USER_PROFILE_WIDTH 45
#define USER_PROFILE_HEIGHT 45


@implementation StickerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.mUserProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
    self.mUserProfileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mUserProfileImageView.layer.cornerRadius=self.mUserProfileImageView.frame.size.width/2;
    self.mUserProfileImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.mUserProfileImageView];
    
    
    
    
    self.mNameLabel = [[UILabel alloc] init];
    [self.mNameLabel setTextColor:[UIColor whiteColor]];
    [self.mNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.mNameLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    self.mNameLabel.textAlignment = NSTextAlignmentCenter;
    self.mNameLabel.layer.cornerRadius = self.mNameLabel.frame.size.width/2;
    self.mNameLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.mNameLabel];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateStickerCell:(ALMessage*)message{
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    ALContactDBService *theContactDBService = [[ALContactDBService alloc] init];
    ALContact *alContact = [theContactDBService loadContactByKey:@"userId" value: message.to];
    
    NSString * receiverName = [alContact getDisplayName];
   self.mUserProfileImageView.alpha = 1;
    self.mUserProfileImageView.backgroundColor = [UIColor whiteColor];;
    if([ALApplozicSettings isUserProfileHidden])
    {
        self.mUserProfileImageView.frame = CGRectMake(USER_PROFILE_PADDING_X, 0, 0, USER_PROFILE_HEIGHT);
    }
    else
    {
        self.mUserProfileImageView.frame = CGRectMake(USER_PROFILE_PADDING_X,
                                                      0, USER_PROFILE_WIDTH, USER_PROFILE_HEIGHT);
    }
    self.mNameLabel.frame = self.mUserProfileImageView.frame;
    [self.mNameLabel setText:[ALColorUtility getAlphabetForProfileImage:receiverName]];
    if(alContact.contactImageUrl)
    {
        NSURL * theUrl1 = [NSURL URLWithString:alContact.contactImageUrl];
        [self.mUserProfileImageView sd_setImageWithURL:theUrl1 placeholderImage:nil options:SDWebImageRefreshCached];
    }
    else
    {
        [self.mUserProfileImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil options:SDWebImageRefreshCached];
        [self.mNameLabel setHidden:NO];
        self.mUserProfileImageView.backgroundColor = [ALColorUtility getColorForAlphabet:receiverName];
    }
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    if ([message.type isEqualToString:@MT_INBOX_CONSTANT]){
        
        [self.ImageViewLeft setHidden:false];
        [self.mUserProfileImageView setHidden:false];
        [self.mNameLabel setHidden:false];
        [self.ImageViewRight setHidden:true];
        [self.lblDateRight setHidden:true];
        [self.chatReadRight setHidden:true];
        NSBundle * bundle =  [NSBundle bundleWithIdentifier:@"org.cocoapods.Applozic"];
        
        UIImage * image = [UIImage imageNamed:message.metadata[@"sticker"] inBundle:bundle compatibleWithTraitCollection:nil];
        self.ImageViewLeft.image = image;
        
    }else{
       
        [self.ImageViewLeft setHidden:true];
          [self.mUserProfileImageView setHidden:true];
          [self.mNameLabel setHidden:true];
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
