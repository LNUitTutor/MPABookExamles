"
Реалізація алгоритмів розділу 3. Поєднання повторення з галуженням
"
Class {
	#name : 'IterationWithBranching',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter03',
	#package : 'MPABookExamples',
	#tag : 'Chapter03'
}

{ #category : 'calculation' }
IterationWithBranching >> check: anArray inCircle: r [
	"Перевіряє, скільки точок (a_i;a_n-i+1) належать кругові з центром (0;0) і радіусом r."

	| k r2 n |
	k := 0.
	r2 := r squared.
	n := anArray size.
	1 to: n // 2 do: [ :i |
		(anArray at: i) squared + (anArray at: n - i + 1) squared <= r2
			ifTrue: [ k := k + 2 ] ].
	n even ifFalse: [
		2 * (anArray at: n // 2 + 1) squared <= r2 ifTrue: [ k := k + 1 ] ].
	^ k
]

{ #category : 'api - running' }
IterationWithBranching >> checkArrInCircle [
	"Задано натуральне число n і дійсні числа r, a_1, a_2, ..., a_n.
 Скільки серед точок (a_1, a_n), (a_2, a_n–1), ..., (a_n, a_1) є таких,
 що належать кругові радіуса r з центром у початку координат?"

	| arr r count |
	arr := self inputArray.
	r := self inputFloatLabeled: 'Введіть дійсне число - радіус круга'.
	count := self check: arr inCircle: r.
	self informAbout:
		'У крузі радіусу ' , r printString , ' міститься '
		, count printString , ' точок'
]

{ #category : 'api - running' }
IterationWithBranching >> countProper [
"Задано натуральне n та n чисел a_i. Обчислити, скільки з них задовольняють умову 2^i < a_i < i!+3"

| n counter |
	n := self inputNatural.
	counter := self countProperAmong: n.
	self informAbout:
		'*** Обчислення кількості "правильних" членів послідовності', String cr,
		'Загальна кількість = ', n printString, String cr,
		'Кількість обраних = ' , counter printString
]

{ #category : 'calculation' }
IterationWithBranching >> countProperAmong: n [
	"Обчислює кількість членів послідовності a_1, ..., a_n, для яких виконується умова 2^i < a_i < i!+3"

	| powerOf2 factorial counter |
	powerOf2 := 1.
	factorial := 1.
	counter := 0.
	1 to: n do: [ :i |
		| a |
		a := self inputNthNumber: i.
		powerOf2 := powerOf2 * 2.
		factorial := factorial * i.
		(powerOf2 < a and: [ a < (factorial + 3) ]) ifTrue: [
			counter := counter + 1 ] ].
	^ counter
]

{ #category : 'output' }
IterationWithBranching >> informAbout: aString [
	"Повідомляє результат у інформаційному вікні, що закривається автоматично"

	UIManager default message: aString title: 'Результати обчислень'
]

{ #category : 'input' }
IterationWithBranching >> inputArray [
	"Отримує від користувача розмір масиву і його значення, повертає створений масив."

	| n arr stream |
	n := self inputNatural.
	arr := Array new: n.
	stream := (self inputSequenceOf: n) readStream.
	1 to: n do: [ :i |
		arr at: i put: (Float readFrom: stream).
		stream next ].
	^ arr
]

{ #category : 'input' }
IterationWithBranching >> inputFloatLabeled: aString [
	"Відкриває вікно діалогу для введення дійсного числа.
	 Не виконує ніяких перевірок"

	^ Float readFrom: (UIManager default
		   textEntry: aString 
		   title: 'Запит') readStream
]

{ #category : 'input' }
IterationWithBranching >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число - кількість членів послідовності'
		   initialAnswer: '2'
		   title: 'Запит') asInteger abs
]

{ #category : 'input' }
IterationWithBranching >> inputNthNumber: n [
	"Відкриває вікно діалогу для введення дійсного числа, n-го члена послідовності.
	 Не виконує ніяких перевірок"

	^ Float readFrom: (UIManager default
		   textEntry: 'Введіть ', n printString, '-e число'
		   title: 'Запит') readStream
]

{ #category : 'input' }
IterationWithBranching >> inputSequenceOf: count [
	"Відкриває вікно діалогу для введення послідовності count чисел. Повертає рядок.
	 Не виконує ніяких перевірок"

	^ UIManager default
		   textEntry: 'Введіть послідовність ', count printString, ' чисел, відокремлених пропуском'
		   title: 'Запит'
]

{ #category : 'output' }
IterationWithBranching >> showWindowLabeled: labelString with: text [
	"Відкриває окреме текстове вікно з об'ємними результатами"

	(SystemWindow labelled: labelString)
		addMorph: (RubScrolledTextMorph new
				 setText: text;
				 font: StandardFonts codeFont;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
]
