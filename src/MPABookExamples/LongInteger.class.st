"
Клас зображає велике ціле - розділ 9 Покркоква розробка програм
"
Class {
	#name : 'LongInteger',
	#superclass : 'Object',
	#instVars : [
		'digits'
	],
	#category : 'MPABookExamples-Chapter09',
	#package : 'MPABookExamples',
	#tag : 'Chapter09'
}

{ #category : 'initialization' }
LongInteger >> initialize [

	digits := OrderedCollection with: 0
]

{ #category : 'calculation' }
LongInteger >> multBy: aNumber [

	| calc transfer |
	aNumber = 0 ifTrue: [ ^ self set: 0 ].
	aNumber = 1 ifTrue: [ ^ self ].
	transfer := 0.
	digits withIndexDo: [ :digit :i |
		calc := digit * aNumber + transfer.
		digits at: i put: calc \\ 10.
		transfer := calc // 10 ].
	[ transfer > 0 ] whileTrue: [
		digits add: transfer \\ 10.
		transfer := transfer // 10 ]
]

{ #category : 'calculation' }
LongInteger >> multByTwo [

	| calc transfer |
	transfer := 0.
	digits withIndexDo: [ :digit :i |
		calc := digit * 2 + transfer.
		digits at: i put: calc \\ 10.
		transfer := calc // 10 ].
	transfer > 0 ifTrue: [ digits add: transfer ]
]

{ #category : 'printing' }
LongInteger >> printOn: stream [

	digits reverseDo: [ :digit | digit printOn: stream ]
]

{ #category : 'initialization' }
LongInteger >> set: aNumber [

	digits removeAll.
	aNumber = 0
		ifTrue: [ digits add: 0 ]
		ifFalse: [ | n | n := aNumber.
			[ n > 0 ] whileTrue: [ 
				digits add: n \\ 10.
				n := n // 10 ] ]
]
