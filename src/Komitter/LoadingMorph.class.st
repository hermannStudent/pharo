"
I am a special iamge morph used to be displayed as an icon for loading
"
Class {
	#name : #LoadingMorph,
	#superclass : #ImageMorph,
	#instVars : [
		'images',
		'currentImageIndex'
	],
	#category : #'Komitter-Support'
}

{ #category : #'as yet unclassified' }
LoadingMorph class >> imageData1 [

	^ #(0 0 0 0 0 0 733526200 3317349050 3099245242 683260345 0 0 0 0 0 0 0 0 61516458 532002229 0 0 2176498362 4290493371 4290493371 2176498362 0 0 632994490 41975936 0 0 0 41975936 2830875579 4290493371 2629483194 179549107 3166354106 4290493371 4290493371 2881141434 263961531 2696592058 4290493371 2696592058 16777216 0 0 548911031 4290493371 4290493371 4290493371 4240095930 4290493371 4290493371 4290493371 4290493371 4240095930 4290493371 4290493371 4290493371 464761779 0 0 0 2579217339 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 2411313593 0 0 0 0 263961531 4256873146 4290493371 4290493371 4290493371 3418012346 3451632571 4290493371 4290493371 4290493371 4189764282 162179754 0 0 548911031 1757067962 2763766715 4290493371 4290493371 4290493371 1438300858 0 0 1572518586 4290493371 4290493371 4290493371 2696592058 1723447737 616085688 3552230074 4290493371 4290493371 4290493371 4290493371 3367680698 0 0 0 0 3485121210 4290493371 4290493371 4290493371 4290493371 3401300923 3569007290 4290493371 4290493371 4290493371 4290493371 3283860411 0 0 0 0 3401300923 4290493371 4290493371 4290493371 4290493371 3535518651 817543866 2042214841 3015424955 4290493371 4290493371 4256873146 1169799609 0 0 1270594491 4273716155 4290493371 4290493371 2981804730 2042214841 767278011 0 0 212511402 4240095930 4290493371 4290493371 4240095930 3099245242 3116022458 4256873146 4290493371 4290493371 4189764282 144678815 0 0 0 0 2361047738 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 2210118587 0 0 0 599176886 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4273716155 431536312 0 0 93952409 3065690810 4290493371 2981804730 666351543 2965093307 4290493371 4290493371 3250240186 498710969 3082533819 4290493371 2965093307 41975936 0 0 0 129414838 1002093242 16777216 0 2042214841 4290493371 4290493371 2243607226 0 41975936 1119467961 93952409 0 0 0 0 0 0 0 0 850966712 3518741435 3501898426 834057910 0 0 0 0 0 0)
]

{ #category : #'as yet unclassified' }
LoadingMorph class >> imageData2 [

	^ #(0 0 0 0 1337505976 649442741 0 0 1186642618 3803888314 2730146490 464761779 0 0 0 0 0 0 0 2914695866 4290493371 4055546554 599176886 16777216 3518741435 4290493371 4290493371 1891351483 0 0 0 0 0 0 0 3585850299 4290493371 4290493371 3585850299 2679814842 4290493371 4290493371 4290493371 1371191994 0 0 0 0 0 0 0 1975105977 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 2461776827 1304017337 3132799674 3485121210 279949231 0 279949231 0 1757067962 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 2260384442 2864364218 4290493371 4156275643 4206607291 4290493371 4290493371 4290493371 3736779450 3552230074 4290493371 4290493371 4290493371 4290493371 4290493371 4273716155 1656338873 4122655418 4290493371 4290493371 4290493371 4290493371 4290493371 1857665465 0 0 1169799609 4172987066 4290493371 4290493371 4089166779 1253751482 0 2495265466 4206607291 4290493371 4290493371 4290493371 3501898426 0 0 0 0 2713435067 4290493371 4290493371 3569007290 0 0 0 464761779 3401300923 4290493371 4290493371 3099245242 0 0 0 0 2361047738 4290493371 4290493371 4290493371 3250240186 1253751482 0 61516458 3149642683 4290493371 4290493371 4105878202 515619771 0 0 212511402 3736779450 4290493371 4290493371 4290493371 4290493371 4290493371 314095800 3216751547 4290493371 4290493371 4290493371 4290493371 3787176891 1924840122 1807399610 3535518651 4290493371 4290493371 4290493371 4290493371 4290493371 4172987066 1941617338 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 3501898426 1555741370 1975105977 1388035003 414561717 4089166779 4290493371 3468409787 3619338938 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 2075900859 0 0 0 0 783792055 934918585 0 263961531 4206607291 4290493371 4290493371 4172987066 4256873146 4290493371 4290493371 3686447802 16777216 0 0 0 0 0 0 800635064 4290493371 4290493371 4290493371 1002093242 1069202106 4240095930 4290493371 4223384507 330215086 0 0 0 0 0 0 565819833 4139498427 4290493371 3149642683 0 0 1840888249 3367680698 1136310970 0 0 0)
]

{ #category : #'as yet unclassified' }
LoadingMorph class >> imageData3 [

	^ #(0 0 0 0 347321267 3401300923 4290493371 2377824954 0 0 431536312 1488566713 93952409 0 0 0 0 0 0 0 901232567 4290493371 4290493371 4139498427 297055412 330215086 3619338938 4290493371 3418012346 229749169 0 0 0 0 0 0 448445114 4290493371 4290493371 4290493371 3283860411 3451632571 4290493371 4290493371 4290493371 498710969 0 0 41975936 2931473082 3132799674 1555741370 1924840122 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 3065690810 0 0 0 1505409722 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 3015424955 229749169 817543866 632994490 1085781943 4156275643 4290493371 4290493371 4290493371 4290493371 4290493371 3585850299 3367680698 4256873146 4290493371 4290493371 4290493371 4290493371 4290493371 4172987066 0 901232567 3870997178 4290493371 4290493371 4290493371 1689959098 0 0 934918585 4105878202 4290493371 4290493371 4290493371 4290493371 4290493371 0 0 3082533819 4290493371 4290493371 3350903482 0 0 0 0 2545597114 4290493371 4290493371 4290493371 4273716155 3048913594 1152956600 3032202171 4256873146 4290493371 4290493371 2981804730 0 0 0 0 2260384442 4290493371 4290493371 4122655418 599176886 0 4273716155 4290493371 4290493371 4290493371 4290493371 4105878202 448445114 0 0 229749169 3686447802 4290493371 4290493371 3887840187 381270457 0 4139498427 4290493371 4290493371 4290493371 4290493371 4290493371 3770399675 1941617338 1840888249 3552230074 4290493371 4290493371 4290493371 4290493371 3787176891 767278011 1656338873 2528885691 1941617338 3552230074 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 2696592058 0 0 0 1438300858 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 4290493371 3703290811 2814032570 4156275643 4273716155 901232567 0 0 0 3267083195 4290493371 4290493371 4273716155 4172987066 4290493371 4290493371 4290493371 1102624952 0 279949231 716617398 0 0 0 0 3954949051 4290493371 4290493371 1958460347 364295862 4122655418 4290493371 4290493371 1522252731 0 0 0 0 0 0 0 532002229 2730146490 2109389498 0 0 2646326203 4290493371 4290493371 1455143867 0 0 0 0)
]

{ #category : #drawning }
LoadingMorph >> drawOn: aCanvas [ 
	
	super drawOn: aCanvas.
	aCanvas paintImage: (images at: currentImageIndex) at: self position
]

{ #category : #drawning }
LoadingMorph >> formFromContents: aByteArray [
	| size |
	size := 16.
	^ Form
		extent: size@size
		depth: 32
		fromArray: aByteArray 
		offset: 0@0
]

{ #category : #initialize }
LoadingMorph >> initialize [

	super initialize.
	
	images := { self class imageData1. self class imageData2. self class imageData3 } collect: [ :data |
		self formFromContents: data ]. 
	currentImageIndex := 1.
	self extent: 16@16.
]

{ #category : #stepping }
LoadingMorph >> step [

	self isStepping ifFalse: [ ^ self ].
	currentImageIndex := ((currentImageIndex + 1) \\ 3)+1.
	self changed
]

{ #category : #stepping }
LoadingMorph >> stepTime [

	^ 60
]