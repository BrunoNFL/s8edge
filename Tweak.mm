#import "CustoWindow.h"

NSMutableDictionary *prefsplistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"var/mobile/Library/Preferences/com.brunonfl.s8edgeprefs.plist"];
NSNumber *tweakEnabled = [prefsplistDict objectForKey:@"Status"];
NSNumber *enableRoundedCorners = [prefsplistDict objectForKey:@"enableRoundedCorners"];
NSNumber *enableEdgeOverlay = [prefsplistDict objectForKey:@"enableEdgeOverlay"];
NSNumber *whitePhone = [prefsplistDict objectForKey:@"whitePhone"];
NSNumber *sliderRadius = [prefsplistDict objectForKey:@"sliderRadius"];
NSNumber *sliderOpacity = [prefsplistDict objectForKey:@"sliderOpacity"];

@interface s8EdgeUI : UIViewController <UITextFieldDelegate>{
  CustoWindow *s8EdgeWindow;
  UIView *backgroundView;
  UIView *roundedCornerView;
  UIView *roundedCornerViewMask;
  UIBezierPath* roundedCornerpath;
}
- (void)getS8EdgePrefs;
- (void)initializeS8EdgeWindow;
@end

@implementation s8EdgeUI
- (id)init{
  self=[super init];
  return self;
}

- (void)initializeS8EdgeWindow{
  [self getS8EdgePrefs];
  if (tweakEnabled == nil || [tweakEnabled boolValue] == YES){
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    //Ultra high level window, I used a custom window to be able to ignore touches and not mess with iPhone functionality
    s8EdgeWindow = [[CustoWindow alloc] initWithFrame: screenRect];
    if ([s8EdgeWindow respondsToSelector:@selector(_setSecure:)]) [s8EdgeWindow _setSecure:YES];
    s8EdgeWindow.windowLevel = 5555555555555;

    //This view is only the canvas to the gradient to be displayed
    double overlayOpacity;
    if (sliderOpacity == nil) {
      overlayOpacity = 0.2;
    }
    else{
      overlayOpacity = ([sliderOpacity floatValue] / 100);
    }
    backgroundView = [[UIView alloc] initWithFrame:screenRect];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.layer.zPosition = MAXFLOAT;
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView setAlpha:overlayOpacity];

    //This view is dedicated to being a black canvas to be masked in whichever way I want
    roundedCornerView = [[UIView alloc] initWithFrame:screenRect];
    roundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    roundedCornerView.layer.zPosition = MAXFLOAT;
    if (whitePhone == nil || [whitePhone boolValue] == NO){
      roundedCornerView.backgroundColor = [UIColor blackColor];
    }
    else{
      roundedCornerView.backgroundColor = [UIColor whiteColor];
    }

    //Here's the start of the masking portion of the code...
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = [[UIScreen mainScreen] bounds];
    maskLayer.fillColor = [UIColor blackColor].CGColor;

    double cornerRadius;
    if (sliderRadius == nil){
      cornerRadius = 12.0;
    }
    else{
      cornerRadius = [sliderRadius floatValue];
    }
    roundedCornerpath = [UIBezierPath bezierPathWithRoundedRect: screenRect cornerRadius: cornerRadius];
    [roundedCornerpath appendPath:[UIBezierPath bezierPathWithRect:screenRect]];

    maskLayer.path = roundedCornerpath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;

    roundedCornerView.layer.mask = maskLayer;
    //...and here's the end of it

    //Here's the implementation of the gradients
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = backgroundView.bounds;
    gradient.colors = @[(id)[UIColor whiteColor].CGColor,
                        (id)/*[UIColor colorWithWhite:1.0 alpha:0.0]*/[UIColor clearColor].CGColor];
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(0.05, 0.5);

    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = backgroundView.bounds;
    gradient2.colors = @[(id)[UIColor whiteColor].CGColor,
                        (id)/*[UIColor colorWithWhite:1.0 alpha:0.0]*/[UIColor clearColor].CGColor];
    gradient2.startPoint = CGPointMake(1.0, 0.5);
    gradient2.endPoint = CGPointMake(0.95, 0.5);

    //Adding the views to their hierarchies
    [backgroundView.layer addSublayer:gradient];
    [backgroundView.layer addSublayer:gradient2];

    //Finally Displaying the views
    if (enableEdgeOverlay == nil || [enableEdgeOverlay boolValue] == YES){
      [s8EdgeWindow addSubview:backgroundView];
    }
    if (enableRoundedCorners == nil || [enableRoundedCorners boolValue] == YES){
      [s8EdgeWindow addSubview:roundedCornerView];
    }
    //[s8EdgeWindow bringSubviewToFront:roundedCornerView];
    [s8EdgeWindow makeKeyAndVisible];
  }
}
- (void)getS8EdgePrefs{
  prefsplistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"var/mobile/Library/Preferences/com.brunonfl.s8edgeprefs.plist"];
  tweakEnabled = [prefsplistDict objectForKey:@"Status"];
  enableRoundedCorners = [prefsplistDict objectForKey:@"enableRoundedCorners"];
  enableEdgeOverlay = [prefsplistDict objectForKey:@"enableEdgeOverlay"];
  whitePhone = [prefsplistDict objectForKey:@"whitePhone"];
  sliderRadius = [prefsplistDict objectForKey:@"sliderRadius"];
  sliderOpacity = [prefsplistDict objectForKey:@"sliderOpacity"];

  if (tweakEnabled != nil){
      tweakEnabled = [NSNumber numberWithBool:[[prefsplistDict objectForKey:@"Status"] boolValue]];
  }
  if (enableRoundedCorners != nil){
      enableRoundedCorners = [NSNumber numberWithBool:[[prefsplistDict objectForKey:@"enableRoundedCorners"] boolValue]];
  }
  if (enableEdgeOverlay != nil){
      enableEdgeOverlay = [NSNumber numberWithBool:[[prefsplistDict objectForKey:@"enableEdgeOverlay"] boolValue]];
  }
}
@end

s8EdgeUI *s8EdgeUIvar;

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1
{
  %orig();
  s8EdgeUIvar = [[s8EdgeUI alloc] init];
  [s8EdgeUIvar initializeS8EdgeWindow];
}
%end
