"
Двійкове дерево, збудоване з TreeNode. Вміє друкувати себе, обчислювати суму елементів
"
Class {
	#name : 'Tree',
	#superclass : 'Object',
	#instVars : [
		'root'
	],
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'examples' }
Tree class >> example1 [

	^ self new root: (TreeNode
			   new: 1
			   withLeft: (TreeNode
					    new: 2
					    withLeft: (TreeNode new: 4)
					    andRight: (TreeNode new: 5))
			   andRight:
			   (TreeNode new: 3 withLeft: nil andRight: (TreeNode new: 6)))
]

{ #category : 'calculation' }
Tree >> preorderSum [

	^ self preorderSum: root
]

{ #category : 'private' }
Tree >> preorderSum: aTree [

	aTree
		ifNil: [ ^ 0 ]
		ifNotNil: [
			^ aTree val + (self preorderSum: aTree left)
			  + (self preorderSum: aTree right) ]
]

{ #category : 'private' }
Tree >> print: aTree by: shift on: stream [

	aTree ifNotNil: [
		self print: aTree left by: shift + 1 on: stream.
		shift timesRepeat: [ stream nextPut: Character tab ].
		stream print: aTree val; cr.
		self print: aTree right by: shift + 1 on: stream ]
]

{ #category : 'printing' }
Tree >> printOn: stream [

	root
		ifNil: [ stream nextPutAll: '(Empty tree)' ]
		ifNotNil: [ self print: root by: 0 on: stream ]
]

{ #category : 'accessing' }
Tree >> root: aTreeNode [

	root := aTreeNode
]

{ #category : 'calculation' }
Tree >> sum [

	root ifNil: [ ^ 0 ] ifNotNil: [ ^ self sumNotEmpty: root ]
]

{ #category : 'private' }
Tree >> sumNotEmpty: aTree [

	| s |
	s := aTree val.
	aTree left ifNotNil: [ s := s + (self sumNotEmpty: aTree left) ].
	aTree right ifNotNil: [ s := s + (self sumNotEmpty: aTree right) ].
	^ s
]
