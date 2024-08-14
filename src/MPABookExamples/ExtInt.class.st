"
""розширене ціле"" містить додатковий ідентифікатор-літеру
"
Class {
	#name : 'ExtInt',
	#superclass : 'Object',
	#instVars : [
		'val',
		'ind'
	],
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'instance creation' }
ExtInt class >> new: anInteger with: aCharacter [

	^ self basicNew
		  val: anInteger;
		  ind: aCharacter
]

{ #category : 'instance creation' }
ExtInt class >> newFrom: anArray [

	^ self basicNew
		  val: (anArray at: 1);
		  ind: (anArray at: 2)
]

{ #category : 'comparing' }
ExtInt >> > anExtInt [
	"'розширені цілі' порівнюють за числом, нехтують літерою"

	^ self val > anExtInt val
]

{ #category : 'accessing' }
ExtInt >> ind [

	^ ind
]

{ #category : 'accessing' }
ExtInt >> ind: aCharacter [

	ind := aCharacter
]

{ #category : 'printing' }
ExtInt >> printOn: stream [

	stream
		print: val;
		nextPut: $-;
		nextPut: ind
]

{ #category : 'accessing' }
ExtInt >> val [

	^ val
]

{ #category : 'accessing' }
ExtInt >> val: anInteger [

	val := anInteger
]
