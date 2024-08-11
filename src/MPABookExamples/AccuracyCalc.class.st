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

{ #category : 'accessing - ui' }
AccuracyCalc class >> runTasks [

	<script>
	| answer |
	answer := UIManager default
		          chooseFrom:
			          #( 'Значення sin(x) як суми ряду'
							 'Сума знакозмінного ряду'
							 'Обчислення коренів алгебричного рівняння'
							 'Числове інтегрування' )
		          values:
		          #( calculateSinus calculateSumm calculateRoots calculateIntegrals )
		          lines: #()
		          title: 'Оберіть задачу'.
	answer ifNotNil: [
		self new perform: answer.
		self runTasks ]
]

{ #category : 'api - running' }
AccuracyCalc >> calculateIntegrals [
	"Обчислити методом лівих прямокутників Integral(sin x, 0, Pi) з точністю 1e-6,
 серію інтегралів S(t) = Integral(t^2 x^2 + 1, -1, 1) для t=0(0.5)3 з точністю 1e-5
 і значення R = Integral((x + 2y)^2, 0, 1, 0, x) з точністю 10-4."

	| stream di |
	stream := String new writeStream.
	stream nextPutAll: '*** Обчислення інтегралів методом лівих прямокутників'; cr; cr;
		nextPutAll: 'Integral(sin,0,Pi) = ';
		print: (self integrate: [ :x | x sin ] from: 0.0 to: Float pi accuracy: 1e-6); cr; cr.
	stream nextPutAll: '   t    S(t)'; cr; nextPutAll: '----------------------'; cr.
	0.0 to: 3.0 by: 0.5 do: [ :t |
		stream nextPutAll: '  '; print: t; nextPutAll: '   ';
			print: (self integrate: [ :x | (x * t) squared + 1.0 ] from: -1.0 to: 1.0 accuracy: 1e-5);
			cr ].
	di := self integrate: [ :x |
		 		self integrate: [ :y | (2 * y + x) squared ] from: 0.0 to: x accuracy: 1e-4]
	 		from: 0.0 to: 1.0 accuracy: 1e-4. 
	stream cr; nextPutAll: 'Подвійний інтеграл повторним числовим інтегруванням'; cr;
		nextPutAll: 'Double integral = ';	print: di; cr.
	self showWindowLabeled: 'Числове інтегрування' with: stream contents
]

{ #category : 'api - running' }
AccuracyCalc >> calculateRoots [
	"Обчислити методом поділу відрізка навпіл корені рівняння x^2+4x–32=0 на проміжках [–8,4; –7,7] та
	 [3,7; 4,2] з точністю 1e–4 і корінь рівняння e^2x=3 на проміжку [0,5; 1] з точністю 1e–8."

	| x1 x2 xe r1 r2 re str |
	x1 := self dichotom: [ :x | (x + 4) * x - 32 ] on: -8.4 to: -7.7 accuracy: 1e-4.
	x2 := self dichotom: [ :x | (x + 4) * x - 32 ] on: 3.7 to: 4.2 accuracy: 1e-4.
	xe := self dichotom: [ :x | (2 * x) exp - 3.0 ] on: 0.5 to: 1.0 accuracy: 1e-8.
	r1 := self dichotomRecursive: [ :x | (x + 4) * x - 32 ] on: -8.4 to: -7.7 accuracy: 1e-4.
	r2 := self dichotomRecursive: [ :x | (x + 4) * x - 32 ] on: 3.7 to: 4.2 accuracy: 1e-4.
	re := self dichotomRecursive: [ :x | (2 * x) exp - 3.0 ] on: 0.5 to: 1.0 accuracy: 1e-8.
	str := String streamContents: [ :stream |
		stream nextPutAll: '*** Обчислення кореня рівняння методом дихотомії:'; cr; cr;
			nextPutAll: ' Ітеративно:'; cr;
			nextPutAll: ' - корені параболи   x1 = '; print: x1;
			nextPutAll: '   x2 = '; print: x2; cr;
			nextPutAll: ' - корінь експоненти   x = '; print: xe; cr; cr.
		stream nextPutAll: ' Рекурсивно:'; cr;
			nextPutAll: ' - корені параболи   x1 = '; print: r1;
			nextPutAll: '   x2 = '; print: r2; cr;
			nextPutAll: ' - корінь експоненти   x = '; print: re; cr ].
	self showWindowLabeled: 'Обчислення кореня алгебричного рівняння' with: str
]

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

{ #category : 'calculation' }
AccuracyCalc >> dichotom: f on: left to: right accuracy: eps [
	"Обчислює методом поділу відрізка навпіл корінь рівняння
    f(x) = 0, x є [a;b]. f - блок з одним аргументом "

	| fa a b |
	a := left.
	b := right.
	fa := f value: a.
	[ b - a > eps ] whileTrue: [ | c fc |
		c := (a + b) * 0.5.
		fc := f value: c.
		fa * fc < 0
			ifTrue: [ b := c ]
			ifFalse: [ a := c.
				fa := fc ] ].
	^ (a + b) * 0.5
]

{ #category : 'calculation' }
AccuracyCalc >> dichotomRecursive: f on: a to: b accuracy: eps [
	"Рекурсивно обчислює методом поділу відрізка навпіл корінь рівняння
    f(x) = 0, x є [a;b]. f - блок з одним аргументом "

	| c |
	c := (a + b) * 0.5.
	b - a <= eps ifTrue: [ ^ c ].
	(f value: a) * (f value: c) < 0
		ifTrue: [ ^ self dichotomRecursive: f on: a to: c accuracy: eps ]
		ifFalse: [ ^ self dichotomRecursive: f on: c to: b accuracy: eps ]
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
AccuracyCalc >> integrate: f from: a to: b accuracy: eps [
	"Обчислює методом лівих прямокутників означений інтеграл функції f(x) на проміжку [a;b] з точністю eps.
    Крок інтегрування вибирається автоматично. Точність коньтролюють за правилом Рунге.
    Дозволено не більше 12 подвоєнь сітки інтегрування."

	| n h sum integN integ2N doublings h2 a2 |
	n := 10.
	h := (b - a) / n.
	sum := 0.0.
	integN := 0.0.
	0 to: n - 1 do: [ :i | sum := sum + (f value: i * h + a) ].
	integ2N := sum * h.
	doublings := 0.
	[ (integ2N - integN) abs / 3.0 > eps and: [ doublings < 13 ] ] whileTrue: [ 
		doublings := doublings + 1.
		integN := integ2N.
		h2 := h * 0.5.
		a2 := a + h2.
		0 to: n - 1 do: [ :i | sum := sum + (f value: i * h + a2) ].
		integ2N := sum * h2.
		h := h2.
		n := n * 2 ].
	doublings > 12 ifTrue: [ UIManager default inform: 'integrate::WARNING: Accuracy loss is possible' ].
	^ integ2N
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

{ #category : 'output' }
AccuracyCalc >> showWindowLabeled: labelString with: text [
	"Відкриває окреме текстове вікно з об'ємними результатами"

	(SystemWindow labelled: labelString)
		addMorph: (RubScrolledTextMorph new
				 setText: text;
				 font: StandardFonts codeFont;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
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
