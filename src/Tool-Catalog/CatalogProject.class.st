"
I'm a project from an official pharo repository. 

I can load 
	- stable versions
	- just configurations.

My class side provides some helper to access distribution repositories.

[[[
self pharoDistributionRepository			
]]]
			
[[[
self availableRepositoryURLStrings		 
]]]
"
Class {
	#name : #CatalogProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'packageName',
		'repositoryUrl',
		'description',
		'keywords',
		'contactInfo'
	],
	#classInstVars : [
		'repositoryURLToNameMappings'
	],
	#category : #'Tool-Catalog-Base'
}

{ #category : #private }
CatalogProject class >> availableRepositoryURLStrings [
	^ self repositoryURLToNameMappings keys
]

{ #category : #private }
CatalogProject class >> createRepositoryURLtoNameMappings [
	"Return a mapping between repositories URLs and their user names"

	^ Dictionary new
		at: self pharoDistributionRepository put: self pharoCurrentDottedName;
		at: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo50/main' put: 'Pharo5.0';
		at: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo40/main' put: 'Pharo4.0';
		at: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo30/main' put: 'Pharo3.0';
		at: 'http://www.squeaksource.com/MetacelloRepository' put: 'Unsorted';
		yourself
]

{ #category : #'instance creation' }
CatalogProject class >> fromDictionary: aDictionary [
	^ self new 
		fromDictionary: aDictionary;
		yourself
]

{ #category : #'GT-InspectorExtensions-Core' }
CatalogProject class >> gtBasicExample [
	<gtExample>
	^ self new fromDictionary: 
		(Dictionary new
			add: ('packageName'->'ConfigurationOfGTInspector'); 
			add: ('name'->'GTInspector'); 
			add: ('repositoryUrl'->'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo50/main'); 
			yourself)
]

{ #category : #private }
CatalogProject class >> pharoCurrentDottedName [
	^ 'Pharo' , SystemVersion current major asString , '.', SystemVersion current minor asString
]

{ #category : #private }
CatalogProject class >> pharoCurrentMajorName [
    
    ^ 'Pharo', SystemVersion current major asString, '0'
]

{ #category : #private }
CatalogProject class >> pharoDistributionRepository [
	"Returns the correct pharo distribution url"

	^ 'http://smalltalkhub.com/mc/Pharo/MetaRepoFor' , self pharoCurrentMajorName , '/main'
]

{ #category : #accessing }
CatalogProject class >> repositoryURLToNameMappings [
	^ repositoryURLToNameMappings ifNil: [ repositoryURLToNameMappings := self createRepositoryURLtoNameMappings ]
]

{ #category : #accessing }
CatalogProject class >> unknownRepository [
	^ 'Unknown'
]

{ #category : #accessing }
CatalogProject >> allKeywords [
	^ self keywords copyWithFirst: self repositoryName
]

{ #category : #accessing }
CatalogProject >> contactInfo [
	^ contactInfo
]

{ #category : #accessing }
CatalogProject >> description [
	^ description
]

{ #category : #initialization }
CatalogProject >> fromDictionary: aDictionary [ 
	name := aDictionary at: #name.
	packageName := aDictionary at: #packageName.
	repositoryUrl := aDictionary at: #repositoryUrl.
	description := aDictionary at: #description ifAbsent: [ nil ].
	contactInfo := aDictionary at: #contactInfo ifAbsent: [ nil ].
	keywords := ((aDictionary 
		at: #keywords  
		ifAbsent: [ #() ])
		ifNil: [ #() ])
		collect: #asLowercase.
]

{ #category : #accessing }
CatalogProject >> fullDescription [
	^ String streamContents: [ :stream | 
		self description
		   ifNil: [ stream << '<No Description Provided>' ]
			ifNotNil: [ stream << self description  ].
		self contactInfo 
			ifNotNil: [ 
				stream cr; cr.
				stream << self contactInfo ] ]
]

{ #category : #'gt-inspector-extension' }
CatalogProject >> gtInspectorDetailsIn: composite [
	<gtInspectorPresentationOrder: 30>
	^ composite table
		title: 'Project';
		display: [ {
			'name' -> self name.
			'package name' -> self packageName.
			'repository url' -> self repositoryUrl.
			'description' -> (self description ifNil: [ '' ]).
			'contact info' -> (self contactInfo ifNil: [ '' ]).
			'keywords' -> (Character space join: self keywords) } ];
		column: 'Key' evaluated: #key;
		column: 'Value' evaluated: #value;
		send: #value
]

{ #category : #installing }
CatalogProject >> installStableVersion [ 
	  Metacello new
		repository: self repositoryUrl, '/',self name;
		configuration: self name;
		version: #'stable';
		load
]

{ #category : #installing }
CatalogProject >> installVersion: aStringOrSymbol [ 
	[ Gofer it 
			url: self repositoryUrl;
			configurationOf: self name;
			loadVersion: aStringOrSymbol ]
	on: Warning do: [ :w | w resume: true ]
]

{ #category : #testing }
CatalogProject >> isAvailableForCurrentPharo [
	^ self repositoryName = Smalltalk version
]

{ #category : #accessing }
CatalogProject >> keywords [
	^ keywords
]

{ #category : #installing }
CatalogProject >> loadConfiguration [ 
	Gofer it 
		url: self repositoryUrl;
		configurationOf: self name;
		load
]

{ #category : #testing }
CatalogProject >> matches: aString [ 
	^ (self matches: self name with: aString)
		or: [ self keywords anySatisfy: [ :each | self matches: each with: aString ] ]
]

{ #category : #private }
CatalogProject >> matches: aString with: subString [
	^ aString
		includesSubstring: subString 
		caseSensitive: false
]

{ #category : #accessing }
CatalogProject >> name [
	^ name
]

{ #category : #accessing }
CatalogProject >> packageName [
	^ packageName
]

{ #category : #printing }
CatalogProject >> printOn: stream [ 
	stream << 'Project(' << self name << ')'
]

{ #category : #accessing }
CatalogProject >> repositoryName [
	^ self class repositoryURLToNameMappings 
		at: self repositoryUrl
		ifAbsent: [ self class unknownRepository ]
]

{ #category : #accessing }
CatalogProject >> repositoryUrl [
	^ repositoryUrl
]

{ #category : #'gt-spotter-extension' }
CatalogProject >> spotterPreviewIn: aComposite [
	<spotterPreview: 10>
	^ aComposite table
		title: 'Catalog Project';
		display: [ {
			'name' -> self name.
			'package name' -> self packageName.
			'repository url' -> self repositoryUrl.
			'description' -> (self description ifNil: [ '' ]).
			'contact info' -> (self contactInfo ifNil: [ '' ]).
			'keywords' -> (Character space join: self keywords) } ];
		column: 'Key' evaluated: #key;
		column: 'Value' evaluated: #value;
		entity: self
]