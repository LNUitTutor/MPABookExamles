"
Переміщення одного диска в задачі про Ханойські вежі
"
Class {
	#name : 'DiskMove',
	#superclass : 'Object',
	#instVars : [
		'from',
		'to'
	],
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'instance creation' }
DiskMove class >> newFrom: source to: dest [

	^ self basicNew
		  from: source;
		  to: dest
]

{ #category : 'accessing' }
DiskMove >> from [

	^ from
]

{ #category : 'accessing' }
DiskMove >> from: aPosition [

	from := aPosition
]

{ #category : 'printing' }
DiskMove >> printOn: aStream [

	aStream
		print: from;
		nextPutAll: ' --> ';
		print: to;
		cr
]

{ #category : 'accessing' }
DiskMove >> to [

	^ to
]

{ #category : 'accessing' }
DiskMove >> to: aPosition [

	to := aPosition
]
