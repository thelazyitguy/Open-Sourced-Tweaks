BOOL hasMovedToWindow = NO;

/*
	Original tweaks: 
	@rpetrich: https://github.com/rpetrich/Cask
	@efrederickson: https://github.com/efrederickson/Cask
	@ryannair05: https://github.com/ryannair05/Cask-2
*/

%hook UIScrollView

- (BOOL)isDragging
{
	hasMovedToWindow = !%orig;
	return %orig;
}

- (void)_scrollViewWillBeginDragging
{
	hasMovedToWindow = NO;
	return %orig;
}

%end 

%hook UITableView

- (UITableViewCell*)_createPreparedCellForGlobalRow: (NSInteger)globalRow withIndexPath: (NSIndexPath *)indexPath willDisplay: (BOOL)willDisplay
{
	__block UITableViewCell *result = %orig;

	if(hasMovedToWindow) return result;

    dispatch_async(dispatch_get_main_queue(), // SLIDE AND BOUNCE ANIMATION
	^{
		CGRect original = result.frame;
		CGRect newFrame = original;
		CGRect newFrame2 = original;
		newFrame2.origin.x -= 25;
		newFrame.origin.x += original.size.width;
		result.frame = newFrame;
		[UIView animateWithDuration: 0.25 delay: 0.0 
		options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseOut 
		animations: ^{ result.frame = newFrame2; }
		completion: ^(BOOL _) { [UIView animateWithDuration: 0.12 animations: ^{ result.frame = original; }]; }];
	});
    return result;
}

%end

%ctor
{
    if(![@"SpringBoard" isEqualToString: [NSProcessInfo processInfo].processName]) %init;
}
