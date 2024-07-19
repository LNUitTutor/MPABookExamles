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

{ #category : 'accessing - ui' }
IterationWithBranching class >> runTasks [

	<script>
	| answer |
	answer := UIManager default
		          chooseFrom:
			          #( 'Скільки є "правильних" серед усіх заданих'
							 'Скільки точок потрапляє в круг'
							 'Максимальний елемент послідовності'
							 'Перевірка впорядкованості'
							 'Пошук місця елемента послідовності' )
		          values:
		          #( countProper checkArrInCircle exchangeFirstWithMax ifIsGrowing insertion )
		          lines: #()
		          title: 'Оберіть задачу'.
	answer ifNotNil: [
		self new perform: answer.
		self runTasks ]
]

{ #category : 'constants' }
IterationWithBranching class >> sizeOfArray [

	^ 10
]

{ #category : 'calculation' }
IterationWithBranching >> backwardSearch: aNumber insertInto: anArray [
	"Вставляє aNumber у впорядкований anArray так, щоб не порушити впорядкованості.
 Пошук місця розпочинає з кінця, одночасно посуває елементи масиву."

	| arr n comparisonPlace |
	arr := anArray copyWith: nil.
	n := anArray size.
	comparisonPlace := n.
	[ comparisonPlace >= 1 and: [ (arr at: comparisonPlace) > aNumber ] ]
		whileTrue: [ arr at: comparisonPlace + 1 put: (arr at: comparisonPlace).
			comparisonPlace := comparisonPlace - 1 ].
	arr at: comparisonPlace + 1 put: aNumber.
	^ arr
]

{ #category : 'calculation' }
IterationWithBranching >> binarySearch: aNumber insertInto: anArray [
	"Вставляє aNumber у впорядкований anArray так, щоб не порушити впорядкованості.
 Щоб знайти місце, застосовує бінарний пошук, тоді посуває хвіст."

	| arr n left right |
	arr := anArray copyWith: nil.
	n := anArray size.
	left := 1.
	right := n + 1.
	[ left ~= right ] whileTrue: [ | middle |
		middle := (left + right) // 2.
		(arr at: middle) < aNumber ifTrue: [ left := middle + 1 ] ifFalse: [ right := middle ] ].
	n to: left by: -1 do: [ :i |
		arr at: i + 1 put: (arr at: i) ].
	arr at: left put: aNumber.
	^ arr
]

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

{ #category : 'api - running' }
IterationWithBranching >> exchangeFirstWithMax [
	"Міняє місцями в заданому масиві перший елемент з найбільшим"

	| arr index indexEnum indexPharo stream max |
	stream := String new writeStream.
	arr := self inputArray.
	stream
		nextPutAll: '*** Обмін першого з найбільшим'; 	cr; cr;
		nextPutAll: 'Заданий масив: '; print: arr; 	cr.
	index := self indexOfMax: arr.
	indexEnum := self indexOfMaxEnumerating: arr.
	indexPharo := self indexOfMaxPharo: arr.
	index ~= 1 ifTrue: [ 
		max := arr at: index.
		arr at: index put: arr first.
		arr at: 1 put: max ].
	stream
		nextPutAll: ' - індекс найбільшого елемента: '; print: index; cr;
		nextPutAll: ' - індекс за допомогою ітератора: '; print: indexEnum; cr;
		nextPutAll: ' - індекс засобами Pharo: '; print: indexPharo; cr;
		nextPutAll: 'Перетворений масив: '; print: arr.
	self showWindowLabeled: 'Обмін елементів масиву' with: stream contents
]

{ #category : 'calculation' }
IterationWithBranching >> forwardSearch: aNumber insertInto: anArray [
	"Вставляє aNumber у впорядкований anArray так, щоб не порушити впорядкованості.
 Шукає місце переглядом зліва направо, тоді посуває хвіст."

	| arr n insertionPlace |
	arr := anArray copyWith: nil.
	n := anArray size.
	insertionPlace := 1.
	[ insertionPlace <= n and: [ (arr at: insertionPlace) < aNumber ] ]
		whileTrue: [ insertionPlace := insertionPlace + 1 ].
	n to: insertionPlace by: -1 do: [ :i |
		arr at: i + 1 put: (arr at: i) ].
	arr at: insertionPlace put: aNumber.
	^ arr
]

{ #category : 'api - running' }
IterationWithBranching >> ifIsGrowing [
	"Перевіряє, чи заданий масив впорядковано за зростанням"

	| arr n last |
	n := self class sizeOfArray.
	arr := self inputArray: n.
	last := self untilIsGrowing: arr.
	self informAbout:
		'*** Перевірка, чи впорядкована послідовність' , String cr
		, arr printString , String cr , (last > n
			 ifTrue: [ 'Послідовність зростаюча' ]
			 ifFalse: [ 'Умову впорядкованості порушено перед а[' , last printString
					, ']' ])
]

{ #category : 'calculation' }
IterationWithBranching >> indexOfMax: anArray [
	"Знаходить індекс першого максимального елемента масиву"

	| index |
	index := 1.
	2 to: anArray size do: [ :i |
		(anArray at: i) > (anArray at: index) ifTrue: [ index := i ] ].
	^ index
]

{ #category : 'calculation' }
IterationWithBranching >> indexOfMaxEnumerating: anArray [
	"Знаходить індекс першого максимального елемента масиву"

	| index maxValue |
	index := 1.
	maxValue := anArray first.
	anArray withIndexDo: [ :elem :i |
		elem > maxValue ifTrue: [ index := i. maxValue := elem ] ].
	^ index
]

{ #category : 'calculation' }
IterationWithBranching >> indexOfMaxPharo: anArray [
	"Знаходить індекс першого максимального елемента масиву"

	^ anArray indexOf: anArray max
]

{ #category : 'output' }
IterationWithBranching >> informAbout: aString [
	"Повідомляє результат у інформаційному вікні, що закривається автоматично"

	UIManager default message: aString title: 'Результати обчислень'
]

{ #category : 'input' }
IterationWithBranching >> inputArray [
	"Отримує від користувача розмір масиву і його значення, повертає створений масив."

	^ self inputArray: (self inputNatural)
]

{ #category : 'input' }
IterationWithBranching >> inputArray: n [
	"Отримує від користувача n значень елементів масиву, повертає створений масив."

	| arr stream |
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

{ #category : 'api - running' }
IterationWithBranching >> insertion [
	"Вставляє задане значення val в заданий масив arr, впорядкований за зростанням"

	| arr val n forwardArr backwardArr binaryArr stream |
	n := self class sizeOfArray.
	arr := (self inputArray: n) sorted.
	val := self inputFloatLabeled: 'Задайте число, яке потрібно вставити в масив'.
	forwardArr := self forwardSearch: val insertInto: arr.
	backwardArr := self backwardSearch: val insertInto: arr.
	binaryArr := self binarySearch: val insertInto: arr.
	stream := String new writeStream.
	stream
		nextPutAll: '*** Вставка числа у впорядковану послідовність'; cr;
		nextPutAll: ' - заданий масив: '; print: arr; cr;
		nextPutAll: ' -  задане число: '; print: val; cr; cr;
		nextPutAll: 'пошук від початку: '; print: forwardArr; cr;
		nextPutAll: '  пошук від кінця: '; print: backwardArr; cr;
		nextPutAll: '  двійковий пошук: '; print: binaryArr; cr.
	self showWindowLabeled: 'Результати вставляння числа' with: stream contents
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

{ #category : 'calculation' }
IterationWithBranching >> untilIsGrowing: anArray [
	"Знаходить індекс закінчення зростаючої частини масиву"

	| i n |
	n := anArray size.
	i := 2.
	[ i <= n and: [ (anArray at: i - 1) < (anArray at: i) ] ] whileTrue: [
		i := i + 1 ].
	^ i
]
