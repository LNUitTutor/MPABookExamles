"
Реалізація алгоритмів розділу 7. Обчислення з заданою точністю
"
Class {
	#name : 'AccuracyCalc',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter07',
	#package : 'MPABookExamples',
	#tag : 'Chapter07'
}

{ #category : 'api - running' }
AccuracyCalc >> calculateSinus [
	"Обчислює синус заданого дійсного числа як суму ряду і стандартним методом"

	| x y z |
	x := self inputFloatPrompt: 'Введіть дійсне число (|x| < 1):'.
	y := self sinSeriesFor: x.
	z := x sin.
	self informAbout: (String streamContents: [ :stream | 
		stream nextPutAll: '*** Обчислення суми ряду - розвинення sin(x)'; cr;
			nextPutAll: 'x = '; print: x; cr;
			nextPutAll: 'sum = '; print: y; cr;
			nextPutAll: 'Sin = '; print: z ])
]

{ #category : 'api - running' }
AccuracyCalc >> calculateSumm [
	"Обчислює суму ряду в заданій точці з заданою точністю"

	| x eps s |
	x := self inputFloatPrompt: 'Введіть дійсне число'.
	eps := self inputFloatPrompt: 'Введіть точність обчислень'.
	s := self seriesSumFor: x withAccuracy: eps.
	self informAbout: (String streamContents: [ :stream | 
		stream nextPutAll: '*** Обчислення суми знакозмінного ряду'; cr;
			nextPutAll: 'x = '; print: x; cr;
			nextPutAll: 'eps = '; print: eps; cr;
			nextPutAll: 'Sum = '; print: s ])
]

{ #category : 'output' }
AccuracyCalc >> informAbout: aString [
	"Повідомляє результат у інформаційному вікні діалогу"

	UIManager default message: aString title: 'Результати обчислень'
]

{ #category : 'input' }
AccuracyCalc >> inputFloatPrompt: aString [
	"Відкриває вікно діалогу для введення дійсного числа, Підказку задають аргументом.
	 Не виконує ніяких перевірок"

	^ Float readFrom: (UIManager default
		   textEntry: aString
		   title: 'Запит') readStream
]

{ #category : 'calculation' }
AccuracyCalc >> seriesSumFor: x withAccuracy: eps [
	"Обчислення суми ряду S((-1)^k x^4k+3 / (2k+1)!(4k+3))"

	| multiplier semiterm term sum k |
	multiplier := x squared.
	semiterm := multiplier * x.
	sum := term := semiterm / 3.
	multiplier := multiplier squared negated.
	k := 0.
	[ term abs > eps ] whileTrue: [ 
		k := k + 1.
		semiterm := semiterm * multiplier / (2 * k * (2 * k + 1)).
		term := semiterm / (4 * k + 3).
		sum := sum + term ].
	^ sum
]

{ #category : 'calculation' }
AccuracyCalc >> sinSeriesFor: x [
	"Обчислення суми ряду Тейлора - розкладу sin(x)"

	| eps xSqr term sum n |
	eps := 1e-6.
	xSqr := x squared negated.
	sum := term := x.
	n := 2.
	[ term abs > eps ] whileTrue: [ 
		term := term * xSqr / n / (n + 1).
		sum := sum + term.
		n := n + 2 ].
	^ sum
]
