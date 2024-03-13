#import <Preferences/Preferences.h>

@interface S8ERootListController : PSListController{
  UIView *back;
  UIView *blurEffectView;
  UILabel *creatorTitle;
  UILabel *creatorSubtitle;
  UILabel *brunoAndrade;
  UILabel *brunoAndradeDescription;
  UIImageView *basePic;
  UIWindow *settingsView;
  UIStatusBarStyle prevStatusStyle;
}
@end

@interface S8EdgeCustomCell : PSTableCell //<PreferencesTableCustomView>
@end
