%hook _UITouchDurationObservingGestureRecognizer

- (void)setMinimumDurationRequired: (double)arg
{
	%orig(DBL_MAX);
}

%end
