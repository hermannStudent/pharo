"
RBMethodNode is the node that that represents AST of a Smalltalk method.

Some properties aren't known to the parser creating this Object. For example, the scope value isn't known by parsing the code but only after doing a
semantic analysis. Likewise the compilation context isn't needed until we try to do the semantic analysis. 

Instance Variables:
	arguments	<SequenceableCollection of: RBVariableNode>	the arguments to the method
	body	<BRSequenceNode>	the body/statements of the method
	nodeReplacements	<Dictionary>	a dictionary of oldNode -> newNode replacements
	replacements	<Collection of: RBStringReplacement>	the collection of string replacements for each node replacement in the parse tree
	selector	<Symbol>	the method name
	keywordsPositions	<IntegerArray | nil>	the positions of the selector keywords
	source	<String>	the source we compiled
	scope	<OCMethodScope | nil> the scope associated with this code of this method
	pragmas	< SequenceableCollection of: RBPragmaNodes > Nodes representing the pragma statements in this method
	compilationContext	<CCompilationContext | CompilationContext>

"
Class {
	#name : #RBMethodNode,
	#superclass : #RBProgramNode,
	#instVars : [
		'scope',
		'selector',
		'keywordsPositions',
		'body',
		'source',
		'arguments',
		'pragmas',
		'replacements',
		'nodeReplacements',
		'compilationContext'
	],
	#category : #'AST-Core-Nodes'
}

{ #category : #'instance creation' }
RBMethodNode class >> selector: aSymbol arguments: valueNodes [
	^(self new)
		selector: aSymbol;
		arguments: valueNodes;
		yourself
]

{ #category : #'instance creation' }
RBMethodNode class >> selector: aSymbol arguments: variableNodes body: aSequenceNode [ 
	^(self new)
		arguments: variableNodes;
		selector: aSymbol;
		body: aSequenceNode;
		yourself
]

{ #category : #'instance creation' }
RBMethodNode class >> selector: aSymbol body: aSequenceNode [ 
	^self 
		selector: aSymbol
		arguments: #()
		body: aSequenceNode
]

{ #category : #'instance creation' }
RBMethodNode class >> selector: aSymbol keywordsPositions: positionList arguments: valueNodes [
	^(self new)
		selector: aSymbol
			keywordsPositions: positionList 
			arguments: valueNodes;
		yourself.
]

{ #category : #comparing }
RBMethodNode >> = anObject [ 
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	(self selector = anObject selector
		and: [ self pragmas size = anObject pragmas size
		and: [ self body = anObject body ] ])
			ifFalse: [ ^ false ].
	self arguments with: anObject arguments do: [ :first :second |
		first = second 
			ifFalse: [ ^ false ] ].
	self pragmas with: anObject pragmas do: [ :first :second |
		first = second 
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #visiting }
RBMethodNode >> acceptVisitor: aProgramNodeVisitor [ 
	^aProgramNodeVisitor visitMethodNode: self
]

{ #category : #accessing }
RBMethodNode >> addNode: aNode [
	^ body addNode: aNode
]

{ #category : #replacing }
RBMethodNode >> addReplacement: aStringReplacement [ 
	replacements ifNil: [^self].
	replacements add: aStringReplacement
]

{ #category : #accessing }
RBMethodNode >> addReturn [
	^ body addReturn
]

{ #category : #accessing }
RBMethodNode >> addSelfReturn [
	^ body addSelfReturn
]

{ #category : #accessing }
RBMethodNode >> allArgumentVariables [
	^(self argumentNames asOrderedCollection)
		addAll: super allArgumentVariables;
		yourself
]

{ #category : #accessing }
RBMethodNode >> allDefinedVariables [
	^(self argumentNames asOrderedCollection)
		addAll: super allDefinedVariables;
		yourself
]

{ #category : #accessing }
RBMethodNode >> argumentNames [
	^ self arguments collect: [:each | each name] as: Array
]

{ #category : #accessing }
RBMethodNode >> arguments [
	^arguments
]

{ #category : #accessing }
RBMethodNode >> arguments: variableNodes [ 
	arguments := variableNodes.
	arguments do: [:each | each parent: self]
]

{ #category : #converting }
RBMethodNode >> asSequenceNode [
	^body
]

{ #category : #accessing }
RBMethodNode >> assignmentNodes [
	^self allChildren select: [:each | each isAssignment].
]

{ #category : #accessing }
RBMethodNode >> blockNodes [
	^self allChildren select: [:each | each isBlock].
]

{ #category : #accessing }
RBMethodNode >> body [
	^body
]

{ #category : #accessing }
RBMethodNode >> body: stmtsNode [ 
	body := stmtsNode.
	body parent: self
]

{ #category : #'private-replacing' }
RBMethodNode >> changeSourceSelector: oldSelector keywordsIntervals: oldIntervals arguments: oldArguments [
	"If this is the same number of arguments, we try a one to one replacement of selector parts and arguments. If this is not the c
ase try to rewrite the signature as a whole, what unfortunately drops the comments within the signature."

	[ (oldIntervals size = self keywordsPositions size and: [ oldArguments size = arguments size ])
		ifTrue: [
			self selectorParts keysAndValuesDo: [ :index :part |
				self addReplacement: (RBStringReplacement 
					replaceFrom: (oldIntervals at: index) first
					to: (oldIntervals at: index) last
					with: part) ].
			oldArguments with: arguments do: [ :old :new | 
				self addReplacement: (RBStringReplacement 
					replaceFrom: old start
					to: old stop
					with: new name) ] ]
		ifFalse: [
			self addReplacement: (RBStringReplacement
				replaceFrom: oldIntervals first first
				to: (oldArguments notEmpty
					ifTrue: [ oldArguments last stop ]
					ifFalse: [ oldIntervals last last ])
				with: (String streamContents: [ :stream |
					self selectorParts keysAndValuesDo: [ :index :part |
						index = 1 ifFalse: [ stream space ].
						stream nextPutAll: part.
						index <= arguments size
							ifTrue: [ stream space; nextPutAll: (arguments at: index) name ] ] ])) ] ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #accessing }
RBMethodNode >> children [
	^ OrderedCollection new
		addAll: self arguments;
		addAll: self pragmas;
		add: self body;
		yourself
]

{ #category : #replacing }
RBMethodNode >> clearReplacements [
	replacements := nil
]

{ #category : #accessing }
RBMethodNode >> compilationContext [
	^ compilationContext
]

{ #category : #accessing }
RBMethodNode >> compilationContext: aCompilationContext [
	compilationContext := aCompilationContext.
]

{ #category : #matching }
RBMethodNode >> copyInContext: aDictionary [
	^ self class new
		selector: self selector;
		arguments: (self arguments collect: [ :each | each copyInContext: aDictionary ]);
		pragmas: (self pragmas isEmpty
			ifTrue: [ aDictionary at: '-pragmas-' ifAbsent: [ #() ] ]
			ifFalse: [ self copyList: self pragmas inContext: aDictionary ]);
		body: (self body copyInContext: aDictionary);
		source: (aDictionary at: '-source-' ifAbsentPut: [ self source ]);
		yourself
]

{ #category : #testing }
RBMethodNode >> defines: aName [
^ (arguments anySatisfy: [ :each | each name = aName ])

		or: [ self pragmas anySatisfy: [ :pragma | pragma defines: aName ] ]
]

{ #category : #comparing }
RBMethodNode >> equalTo: anObject withMapping: aDictionary [ 
	self class = anObject class ifFalse: [ ^ false ].
	(self selector = anObject selector
		and: [ self pragmas size = anObject pragmas size
		and: [ self body equalTo: anObject body withMapping: aDictionary ] ]) 
			ifFalse: [ ^ false ].
	self arguments with: anObject arguments do: [ :first :second |
		(first equalTo: second	withMapping: aDictionary)
			ifFalse: [ ^ false ].
		aDictionary removeKey: first name ].
	self pragmas with: anObject pragmas do: [ :first :second |
		(first equalTo: second	withMapping: aDictionary) 
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
RBMethodNode >> firstPrecodeComment [
	| comment  | 
	self comments ifEmpty: [ ^nil ].
	comment :=  self comments first.
	^self source copyFrom: comment start to: comment stop.
]

{ #category : #testing }
RBMethodNode >> hasArgumentNamed: aString [	
	^ self arguments anySatisfy: [ :argument| argument name = aString ]
]

{ #category : #testing }
RBMethodNode >> hasPragmaNamed: aSymbol [	
	self pragmaNamed: aSymbol ifAbsent: [ ^ false ].
	^ true
]

{ #category : #testing }
RBMethodNode >> hasTemporaryNamed: aString [	
	^ self temporaries anySatisfy: [ :temp| temp name = aString ]
]

{ #category : #comparing }
RBMethodNode >> hash [
	^ ((self selector hash bitXor: (self hashForCollection: self arguments)) bitXor: (self hashForCollection: self pragmas)) bitXor: self body hash
]

{ #category : #initialization }
RBMethodNode >> initialize [
	replacements := SortedCollection sortBlock: 
					[:a :b | 
					a startPosition < b startPosition 
						or: [a startPosition = b startPosition and: [a stopPosition < b stopPosition]]].
	nodeReplacements := IdentityDictionary new
]

{ #category : #accessing }
RBMethodNode >> instanceVariableReadNodes [
		^self variableReadNodes select: [:each | each isInstance]
]

{ #category : #accessing }
RBMethodNode >> instanceVariableWriteNodes [
		^self variableWriteNodes select: [:each | each isInstance]
]

{ #category : #testing }
RBMethodNode >> isFaulty [
	(self arguments anySatisfy: #isFaulty) ifTrue:[ ^true].
	(self pragmas anySatisfy: #isFaulty) ifTrue:[ ^true].
	^self body isFaulty
]

{ #category : #testing }
RBMethodNode >> isLast: aNode [ 
	^body isLast: aNode
]

{ #category : #testing }
RBMethodNode >> isMethod [
	^true
]

{ #category : #testing }
RBMethodNode >> isPrimitive [
	^ self pragmas anySatisfy: [ :each | each isPrimitive ]
]

{ #category : #accessing }
RBMethodNode >> keywords [
	^ selector keywords.
]

{ #category : #accessing }
RBMethodNode >> keywordsIntervals [
	^selector keywords
		with: self keywordsPositions 
		collect: [:keyword :start| start to: (start = 0 ifTrue: [ -1 ] ifFalse: [ start + keyword size - 1]) ]
]

{ #category : #accessing }
RBMethodNode >> keywordsPositions [
	^keywordsPositions ifNil: [ (selector keywords collect: [:char| 0 ]) asIntegerArray ]
]

{ #category : #accessing }
RBMethodNode >> keywordsPositions: aPositionsList [
	keywordsPositions := aPositionsList ifNotNil: [:list| list asIntegerArray ]
]

{ #category : #testing }
RBMethodNode >> lastIsReturn [
	^body lastIsReturn
]

{ #category : #replacing }
RBMethodNode >> map: oldNode to: newNode [ 
	nodeReplacements at: oldNode put: newNode
]

{ #category : #replacing }
RBMethodNode >> mappingFor: oldNode [ 
	^nodeReplacements at: oldNode ifAbsent: [oldNode]
]

{ #category : #matching }
RBMethodNode >> match: aNode inContext: aDictionary [ 
	self class = aNode class ifFalse: [ ^ false ].
	aDictionary at: '-source-' put: aNode source.
	self selector = aNode selector ifFalse: [ ^ false ].
	^ (self matchList: arguments against: aNode arguments inContext: aDictionary)
		and: [ (self matchPragmas: self pragmas against: aNode pragmas inContext: aDictionary)
		and: [ body match: aNode body inContext: aDictionary ] ]
]

{ #category : #matching }
RBMethodNode >> matchPragmas: matchNodes against: pragmaNodes inContext: aDictionary [
	matchNodes isEmpty ifTrue: [ 
		aDictionary at: '-pragmas-' put: pragmaNodes.
		^ true ].
	^ matchNodes allSatisfy: [ :matchNode |
		pragmaNodes anySatisfy: [ :pragmaNode |
			matchNode match: pragmaNode inContext: aDictionary ] ]
]

{ #category : #accessing }
RBMethodNode >> methodClass [
	^self compilationContext getClass 
]

{ #category : #accessing }
RBMethodNode >> methodClass: aClass [	
	compilationContext ifNil: [compilationContext := aClass compiler compilationContext].
	self compilationContext class: aClass
]

{ #category : #accessing }
RBMethodNode >> methodComments [
	| methodComments |
	methodComments := OrderedCollection withAll: self comments.
	arguments do: [:each | methodComments addAll: each comments].
	^methodComments asSortedCollection: [:a :b | a start < b start]
]

{ #category : #accessing }
RBMethodNode >> methodNode [
	^self
]

{ #category : #accessing }
RBMethodNode >> newSource [
	replacements ifNil: [^self formattedCode].
	^[self reformatSource] on: Error do: [:ex | ex return: self formattedCode]
]

{ #category : #accessing }
RBMethodNode >> numArgs [
	^self selector numArgs
]

{ #category : #copying }
RBMethodNode >> postCopy [
	super postCopy.
	self arguments: (self arguments collect: [ :each | each copy ]).
	self pragmas: (self pragmas collect: [ :each | each copy ]).
	self body: self body copy
]

{ #category : #testing }
RBMethodNode >> pragmaNamed: aSymbol [	
	^ self pragmaNamed: aSymbol ifAbsent: [ KeyNotFound signalFor: aSymbol  ]
]

{ #category : #testing }
RBMethodNode >> pragmaNamed: aSymbol ifAbsent: absentBlock [
	^ self pragmas 
		detect: [ :pragma| pragma selector = aSymbol ]
		ifNone: absentBlock
]

{ #category : #testing }
RBMethodNode >> pragmaNamed: aSymbol ifPresent: foundBlock [
	^ self pragmas 
		detect: [ :pragma| pragma selector = aSymbol ]
		ifFound: foundBlock
]

{ #category : #accessing }
RBMethodNode >> pragmas [
	^ pragmas ifNil: [ #() ]
]

{ #category : #accessing }
RBMethodNode >> pragmas: aCollection [
	pragmas := aCollection.
	pragmas do: [ :each | each parent: self ]
]

{ #category : #accessing }
RBMethodNode >> primitiveSources [
	^ self pragmas collect: [ :each | self source copyFrom: each first to: each last ]
]

{ #category : #printing }
RBMethodNode >> printOn: aStream [ 
	aStream nextPutAll: self formattedCode
]

{ #category : #testing }
RBMethodNode >> references: aVariableName [ 
	^body references: aVariableName
]

{ #category : #private }
RBMethodNode >> reformatSource [
	| stream newSource newTree |
	stream := (String new: source size + 100) writeStream.
	stream
		nextPutAll: (source
			copyFrom: (replacements
				inject: 1
				into: [ :sum :each | 
					stream
						nextPutAll: (source copyFrom: sum to: each startPosition - 1);
						nextPutAll: (each string).
					each stopPosition + 1 ])
			to: source size).
	newSource := stream contents.
	newTree := RBParser 
		parseMethod: newSource 
		onError: [ :msg :pos | ^ self formattedCode ].
	self = newTree
		ifFalse: [ ^ self formattedCode ].
	^ newSource
]

{ #category : #accessing }
RBMethodNode >> renameSelector: newSelector andArguments: varNodeCollection [ 
	| oldIntervals oldArguments oldSelector |
	oldSelector := selector.
	oldIntervals := self keywordsIntervals.
	oldArguments := arguments.
	self
		arguments: varNodeCollection;
		selector: newSelector.
	self changeSourceSelector: oldSelector keywordsIntervals: oldIntervals arguments: oldArguments
]

{ #category : #replacing }
RBMethodNode >> replaceNode: aNode withNode: anotherNode [ 
	aNode == body ifTrue: [self body: anotherNode].
	self arguments: (arguments 
				collect: [:each | each == aNode ifTrue: [anotherNode] ifFalse: [each]])
]

{ #category : #accessing }
RBMethodNode >> scope [
	^ scope
]

{ #category : #accessing }
RBMethodNode >> scope: aScopedNode [
	scope := aScopedNode
]

{ #category : #accessing }
RBMethodNode >> selector [
	^ selector
]

{ #category : #accessing }
RBMethodNode >> selector: aSelector [
	keywordsPositions := nil.
	selector := aSelector asSymbol.
]

{ #category : #'initialize-release' }
RBMethodNode >> selector: aSymbol keywordsPositions: positionList arguments: valueNodes [
	self 
		arguments: valueNodes;
		selector: aSymbol;
		keywordsPositions: positionList.
]

{ #category : #accessing }
RBMethodNode >> selectorAndArgumentNames [
	"Returns the selector and argument names portion of a method as a string"

	^ self arguments
		ifEmpty: [self keywords first]
		ifNotEmpty: [| lastArgument |
			lastArgument := self arguments last.
			self source first: lastArgument start + (lastArgument name size - 1)]
]

{ #category : #accessing }
RBMethodNode >> selectorParts [
	^ self keywords collect: #asSymbol.
]

{ #category : #accessing }
RBMethodNode >> sendNodes [
	^self allChildren select: [:each | each isMessage].
]

{ #category : #accessing }
RBMethodNode >> source [
	^source
]

{ #category : #accessing }
RBMethodNode >> source: anObject [
	source := anObject
]

{ #category : #accessing }
RBMethodNode >> sourceCode [
	"compatibility to MethodNode"
	^source
]

{ #category : #accessing }
RBMethodNode >> start [
	^ 1
]

{ #category : #accessing }
RBMethodNode >> statements [
	^ self body statements
]

{ #category : #accessing }
RBMethodNode >> statements: aCollection [
	self body statements: aCollection 
]

{ #category : #accessing }
RBMethodNode >> stop [
	^ self newSource size
]

{ #category : #accessing }
RBMethodNode >> tempVariableReadNodes [
		^self variableReadNodes select: [:each | each isTemp]
]

{ #category : #accessing }
RBMethodNode >> temporaries [
	^ self body temporaries
]

{ #category : #accessing }
RBMethodNode >> temporaryNames [
	^ self body temporaryNames
]

{ #category : #testing }
RBMethodNode >> uses: aNode [ 
	^body == aNode and: [aNode lastIsReturn]
]

{ #category : #accessing }
RBMethodNode >> variableNodes [
		^self allChildren select: [:each | 
			each isVariable and: [each isDefinition not]].
]

{ #category : #accessing }
RBMethodNode >> variableReadNodes [
	^self variableNodes select: [:each | each isRead]
]

{ #category : #accessing }
RBMethodNode >> variableWriteNodes [
		^self variableNodes select: [:each | each isWrite]
]