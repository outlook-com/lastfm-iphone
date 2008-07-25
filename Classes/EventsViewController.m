#import "EventsViewController.h"
#import "MobileLastFMApplicationDelegate.h"
#import "NSString+MD5.h"
#import "NSString+URLEscaped.h"
#import "version.h"

@implementation EventsViewController
@synthesize events;
- (void)_buildCalendar {
	NSInteger x=0, y=0, day=0;
	[[_days subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
	[components setDay:1];
	NSDate *monthStart = [[NSCalendar currentCalendar] dateFromComponents:components];
	
	components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:monthStart];
	x = [components weekday]-1;

	components = [[NSDateComponents alloc] init];
	[components setMonth:1];
	NSDate *nextMonth = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:monthStart options:0];
	[components release];
	int daysInMonth = [nextMonth timeIntervalSinceDate:monthStart] / DAYS;

	int dayWidth = _days.frame.size.width / 7;
	int dayHeight = _days.frame.size.height / ((x + daysInMonth)/7 + 1);
	
	for(day=0; day<daysInMonth; day++) {
		UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		b.frame = CGRectMake(x*dayWidth,y*dayHeight,dayWidth,dayHeight);
		[b setTitle:[NSString stringWithFormat:@"%i", day+1] forState:UIControlStateNormal];
		[_days addSubview: b];
		x++;
		if(x>6) {
			x=0;
			y++;
		}
	}
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMM yyyy"];
	_month.text = [formatter stringFromDate:date];
	[formatter release];
}
- (void)viewDidLoad {
	date = [[NSDate date] retain];
	[self _buildCalendar];
}
- (void)prevMonthButtonPressed:(id)sender {
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setMonth:-1];
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	[date release];
	date = [newDate retain];
	[components release];
	[self _buildCalendar];
}
- (void)nextMonthButtonPressed:(id)sender {
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setMonth:1];
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	[date release];
	date = [newDate retain];
	[components release];
	[self _buildCalendar];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc {
	[super dealloc];
	[events release];
	[date release];
}
@end
