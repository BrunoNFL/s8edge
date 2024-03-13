#import "CustoWindow.h"

@implementation CustoWindow

- (CustoWindow *)init {
	self = [super init];
	return self;
}

//Prevents touches from being blocked by the window
- (BOOL)_ignoresHitTest {
	return YES;
}
@end
