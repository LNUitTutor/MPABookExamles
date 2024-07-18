"
Реалізація алгоритмів розділу 2. Програми з простим повторенням
"
Class {
	#name : 'StepByStep',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter02',
	#package : 'MPABookExamples',
	#tag : 'Chapter02'
}

{ #category : 'api - running' }
StepByStep >> average [
	"Обчислення середнього арифметичного послідовності чисел невідомого розміру.
 Послідовність закінчується нулем."

	| result |
	self informAbout:
		'Введіть по одному числу послідовність, що закінчується нулем'.
	result := self averageStopedBy: 0.
	self informAbout: result
]

{ #category : 'calculation' }
StepByStep >> averageStopedBy: term [
	"Обчислює середнє арифметичне послідовності дійсних чисел з термінальним елементом term.
	 Повертає рядок - зображення результату."

	| quantity sum a |
	quantity := 0.
	sum := 0.0.
	a := self inputNthNumber: quantity + 1.
	[ a ~= term ] whileTrue: [
		sum := sum + a.
		quantity := quantity + 1.
		a := self inputNthNumber: quantity + 1 ].
	^ '*** Обчислення середнього арифметичного послідовності ', quantity printString, ' чисел ',
	 String cr, (quantity = 0
		   ifTrue: [ 'Послідовність починається нулем' ]
		   ifFalse: [ 'Середнє арифметичне = ', (sum / quantity) printString ])
]

{ #category : 'api - running' }
StepByStep >> buildTable [
	"Будує таблицю значень двох функцій, виводить її  вокремому вікні"

	self
		showWindowLabeled: 'Таблиця значень функцій sin x, cos x'
		with: (self tabulateFor: 12)
]

{ #category : 'output' }
StepByStep >> informAbout: aString [
	"Повідомляє результат у інформаційному вікні, що закривається автоматично"

	UIManager default message: aString title: 'Результати обчислень'
]

{ #category : 'input' }
StepByStep >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число'
		   initialAnswer: '1'
		   title: 'Запит') asInteger abs
]

{ #category : 'input' }
StepByStep >> inputNthNumber: n [
	"Відкриває вікно діалогу для введення дійсного числа, n-го члена послідовності.
	 Не виконує ніяких перевірок"

	^ Float readFrom: (UIManager default
		   textEntry: 'Введіть ', n printString, '-e число'
		   title: 'Запит') readStream
]

{ #category : 'input' }
StepByStep >> inputSequenceOf: count [
	"Відкриває вікно діалогу для введення послідовності count чисел. Повертає рядок.
	 Не виконує ніяких перевірок"

	^ UIManager default
		   textEntry: 'Введіть послідовність', count printString, ' чисел, відокремлених пропуском'
		   title: 'Запит'
]

{ #category : 'output' }
StepByStep >> print: aNumber on: aStream width: w digits: d [
	"Друкує число aNumber в потік aStream у полі шириною w з d значащими цифрами"

	aNumber = 0.0
		ifTrue: [
			w - d - 2 timesRepeat: [ aStream nextPut: Character space ].
			aStream nextPutAll: '0.'.
			d timesRepeat: [ aStream nextPut: $0 ] ]
		ifFalse: [
			w - d - 3 timesRepeat: [ aStream nextPut: Character space ].
			aStream nextPut: (aNumber < 0
					 ifTrue: [ $- ]
					 ifFalse: [ Character space ]).
			aNumber abs absPrintOn: aStream base: 10 digitCount: d ]
]

{ #category : 'api - running' }
StepByStep >> quadraticMean [
	"Задано натуральне n та n чисел. Обчислити їхнє середнє квадратичне"

	| n mean |
	n := self inputNatural.
	mean := self quadraticMeanOf: n.
	self informAbout:
		'*** Середнє квадратичне заданої кількості дійсних чисел', String cr,
		'кількість = ', n printString, String cr,
		'Середнє квадратичне = ' , mean printString
]

{ #category : 'calculation' }
StepByStep >> quadraticMeanOf: count [
	"Обчислює середнє квадратичне заданої послідовності count чисел.
 Числа вводить по одному."

	| sum a |
	sum := 0.0.
	1 to: count do: [ :i |
		a := self inputNthNumber: i.
		sum := sum + a squared ].
	^ (sum / count) sqrt
]

{ #category : 'output' }
StepByStep >> showWindowLabeled: labelString with: text [
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
StepByStep >> tabulateFor: nodes [
	"Будує таблицю значень функцій sin(x), cos(x) для xє[0;Pi] у nodes вузлах.
 Повертає форматований рядок."

	| x sinX cosX h stream |
	h := Float pi / nodes.
	stream := WriteStream on: String new.
	stream
		nextPutAll: '  x     sin x    cos x'; cr;
		nextPutAll: '------------------------'; cr.
	0 to: nodes do: [ :i |
		x := h * i.
		sinX := x sin.
		cosX := x cos.
		self
			print: x	on: stream width: 5 digits: 3;
			print: sinX 	on: stream width: 9 digits: 5;
			print: cosX 	on: stream width: 9 digits: 5.
		stream cr ].
	^ stream contents
]
