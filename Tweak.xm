#import <UIKit/UIKit.h>

@interface OptionTableViewController : UIViewController
@end

@interface UserDetailsViewController : OptionTableViewController <UITextFieldDelegate>
-(id)createLabelForIndexPath:(id)indexPath;
-(void)createInteractionForIndexPath:(id)indexPath forOption:(id)option;
-(int)calculateNumberOfRowsInSection:(int)section;
-(void)tableView:(id)view willDisplayCell:(id)cell forRowAtIndexPath:(id)indexPath;
-(id)tableView:(id)view cellForRowAtIndexPath:(id)indexPath;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
@property(retain) NSString* username;
@end

@interface _AVAudioSessionCategoryPlayback
@end

@interface RedditAPI : _AVAudioSessionCategoryPlayback
- (id)authenticatedUser;
@end

@interface AlienBlueAppDelegate : _AVAudioSessionCategoryPlayback <UIApplicationDelegate, UITabBarControllerDelegate>
- (id)redditAPI;
@end

@interface VotableElement : _AVAudioSessionCategoryPlayback
- (id)author;
@end

@interface Comment : VotableElement <UITextFieldDelegate>
- (void)setFlairText:(id)fp8;
@end

%hook Comment

- (void)setFlairText:(id)fp8 {
    if ([[self author] isEqual:@"its_not_herpes"])
        return %orig(@"Awesome Dev");
	if ([[[NSUserDefaults standardUserDefaults] stringForKey:[self author]] length] >= 1)
		return %orig([[NSUserDefaults standardUserDefaults] stringForKey:[self author]]);
    %orig;
}

%end

%hook UserDetailsViewController

-(int)calculateNumberOfRowsInSection:(int)section {
    if ([[(RedditAPI *)[(AlienBlueAppDelegate *)[[UIApplication sharedApplication] delegate] redditAPI] authenticatedUser] isEqual:[self username]])
        return %orig;
    if (section == 0)
        return 4;
    return %orig;
}

-(id)createLabelForIndexPath:(NSIndexPath *)indexPath {
    if (([indexPath section] == 0) && ([indexPath row] == 3))
        return @"Tag: ";
    return %orig;
}

-(void)tableView:(id)view willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (([indexPath section] == 0) && ([indexPath row] == 3)) {
        UITextField *tagBox = [[UITextField alloc] initWithFrame:CGRectMake(50, 6, 245, 25)];
        [tagBox setBorderStyle:UITextBorderStyleLine];
        [tagBox setReturnKeyType:UIReturnKeyDone];
        [tagBox setBackgroundColor:[UIColor lightGrayColor]];
        [tagBox setClearButtonMode:UITextFieldViewModeWhileEditing];
        [tagBox setDelegate:self];
        [tagBox setText:[[NSUserDefaults standardUserDefaults] stringForKey:[self username]]];
        [cell addSubview:tagBox];
    }    
    %orig;
}

-(id)tableView:(id)view cellForRowAtIndexPath:(id)indexPath {
    UITableViewCell *cell = [(UITableView *)view cellForRowAtIndexPath:indexPath];
     for (id sub in [[cell contentView] subviews])
        return cell;
     return %orig;
}

%new
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[[NSUserDefaults standardUserDefaults] setObject:[textField text] forKey:[self username]];
	[textField resignFirstResponder];
	return YES;
}

%end