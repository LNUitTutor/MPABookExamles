"
Екземпляр класу розв'язує задачу про Ханойські вежі: накопичує команди переміщення дисків у колекції moves
"
Class {
	#name : 'HanoiSolwer',
	#superclass : 'Object',
	#instVars : [
		'moves'
	],
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'initialization' }
HanoiSolwer >> initialize [

	moves := OrderedCollection new
]

{ #category : 'calculation' }
HanoiSolwer >> moveTower: height from: source to: dest using: work [
	"Будує послідовність команд про переміщення вежі з height дисків
 зі стержня source на стержень dest"

	height = 1
		ifTrue: [ moves add: (DiskMove newFrom: source to: dest) ]
		ifFalse: [ 
			self moveTower: height - 1 from: source to: work using: dest.
			moves add: (DiskMove newFrom: source to: dest).
			self moveTower: height - 1 from: work to: dest using: source ]
]

{ #category : 'printing' }
HanoiSolwer >> printSolutionOn: stream [

	moves do: [ :move | move printOn: stream ]
]

{ #category : 'calculation' }
HanoiSolwer >> solve: height [
	"Метод створює стержні і запускає метод переміщення вежі заданої висоти"

	self
		moveTower: height
		from: Left new
		to: Right new
		using: Middle new
]
