tests
testDurationMoreThanMaxTicks
	"In #handleTimerEvent the maximum tick is hardcoded as 1000 milliseconds.
	 Test when delay duration is less than this.
		- duration is in milliseconds.
		- ticks are in microseconds"
	| duration  nowTick nextTick expectedTick scheduler |
	duration := 1234 milliSeconds. "simply more than maxTicks"
	nowTick := 100 milliSeconds.
	expectedTick := nowTick + duration.

	scheduler := self delaySchedulerClass new.
	scheduler schedule: duration asDelay. 
	nextTick := scheduler handleTimerEvent: nowTick asMicroseconds.

	self assert: nextTick  equals: expectedTick asMicroseconds.
	self assert: scheduler testCaseSupportActiveDelay millisecondDelayDuration 
			equals: duration asMilliSeconds.
	