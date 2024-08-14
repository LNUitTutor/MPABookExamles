"
Вузол двійкового дерева
"
Class {
	#name : 'TreeNode',
	#superclass : 'Object',
	#instVars : [
		'val',
		'left',
		'right'
	],
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'instance creation' }
TreeNode class >> new: aNumber [

	^ self new: aNumber withLeft: nil andRight: nil
]

{ #category : 'instance creation' }
TreeNode class >> new: aNumber withLeft: leftTree andRight: rightTree [

	^ self basicNew
		  val: aNumber;
		  left: leftTree;
		  right: rightTree
]

{ #category : 'initialization' }
TreeNode >> initialize [

	val := 0
]

{ #category : 'accessing' }
TreeNode >> left [

	^ left
]

{ #category : 'accessing' }
TreeNode >> left: aTreeNode [

	left := aTreeNode
]

{ #category : 'printing' }
TreeNode >> printOn: stream [

	stream
		nextPut: $(;
		print: left;
		nextPutAll: ' <- ';
		print: val;
		nextPutAll: ' -> ';
		print: right;
		nextPut: $)
]

{ #category : 'accessing' }
TreeNode >> right [

	^ right
]

{ #category : 'accessing' }
TreeNode >> right: aTreeNode [

	right := aTreeNode
]

{ #category : 'accessing' }
TreeNode >> val [

	^ val
]

{ #category : 'accessing' }
TreeNode >> val: aNumber [

	val := aNumber
]
