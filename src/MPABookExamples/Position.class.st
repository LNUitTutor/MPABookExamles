"
Один зі стержнів у задачі про Ханойські вежі. Його завдання - друкувати назву стержня
"
Class {
	#name : 'Position',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'printing' }
Position >> printOn: aStream [
	"Universal method for all subclasses"

	aStream nextPutAll: self className
]
