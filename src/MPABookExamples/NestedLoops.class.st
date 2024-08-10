"
Реалізація алгоритмів розділу 4. Вкладені цикли в матричних задачах.


Матриці можна реалізувати об'єктами класу `Array2D`, але у Pharo 12 його не підтримують більше, тому варто скористатися новим `CTArray2D`.
Якщо у образі вашої системи немає такого класу, завантажте його зі сховища [Containers-Array2D](https://github.com/pharo-containers/Containers-Array2D), або просто виконайте наведений нижче фрагмент коду
```
Metacello new
  baseline: 'ContainersArray2D';
  repository: 'github://pharo-containers/Containers-Array2D/src';
  load.
```
"
Class {
	#name : 'NestedLoops',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter04',
	#package : 'MPABookExamples',
	#tag : 'Chapter04'
}

{ #category : 'calculation' }
NestedLoops >> addArray: a with: b [

	^ CTArray2D
		  fromArray: (a contents with: b contents collect: [ :aElem :bElem | aElem + bElem ])
		  width: a width
]

{ #category : 'calculation' }
NestedLoops >> addLoopsArray: a with: b [

	| c n m |
	n := a width.
	m := a height.
	c := CTArray2D width: n height: m.
	1 to: n do: [ :i |
		1 to: m do: [ :j |
			c at: i @ j put: (a at: i @ j) + (b at: i @ j)
		]
	].
	^ c
]

{ #category : 'calculation' }
NestedLoops >> addMatrix: a with: b [

	^ a with: b collect: [ :aRow :bRow |
		  aRow with: bRow collect: [ :aElem :bElem | aElem + bElem ] ]
]

{ #category : 'api - running' }
NestedLoops >> addMatrixes [
	"Додає дві задані матриці різними способами. Заради простоти доданки створюють програмно"

	| n aMatrix bMatrix cMatrix anArray bArray cArray dArray str |
	n := self inputNatural.
	aMatrix := self buildTriangleMatrix: n.
	anArray := self refillTriangleArray2D: n.
	bMatrix := self buildUnitaryMatrix: n.
	bArray := self fillUnitaryArray2D: n.
	cMatrix := self addMatrix: aMatrix with: bMatrix.
	cArray := self addArray: anArray with: bArray.
	dArray := self addLoopsArray: anArray with: bArray.
	str := String streamContents: [ :stream |
		stream nextPutAll: '*** Додавання матриць заданого розміру:'; cr;
			nextPutAll: ' трикутної та одиничної'; cr; cr;
			nextPutAll: ' - Трикутна матриця'; cr.
			self printMatrix: aMatrix on: stream.
			stream nextPutAll: ' - Сума заданої та одиничної'; cr.
			self printMatrix: cMatrix on: stream.
			stream nextPutAll: ' - Додавання вмісту двовимірних масивів'; cr.
			cArray printGridOn: stream.
			stream nextPutAll: ' - Поелементне додавання двовимірних масивів'; cr.
			dArray printGridOn: stream ].
	self showWindowLabeled: 'Обчислення суми матриць' with: str
]

{ #category : 'calculation' }
NestedLoops >> buildTriangleMatrix: n [
	"Створює масив масивів, верхньотрикутну матрицю порядку n, розділену побічною діагоналлю."

	| matrix |
	matrix := self createMatrix: n.
	1 to: n do: [ :i | (matrix at: i) at: n - i + 1 put: n ].
	1 to: n - 1 do: [ :i |
		1 to: n - i do: [ :j |
			(matrix at: i) at: j put: i + j - 1 ] ].
	2 to: n do: [ :i |
		n - i + 2 to: n do: [ :j |
			(matrix at: i) at: j put: 0 ] ].
	^ matrix
]

{ #category : 'calculation' }
NestedLoops >> buildUnitaryArray2D: n [
	"Створює двохвимірний масив, одиничну матрицю порядку n, за допомогою конструктора."

	^ CTArray2D width: n height: n tabulate: [ :i :j | i = j ifTrue: [ 1 ] ifFalse: [ 0 ] ]
]

{ #category : 'calculation' }
NestedLoops >> buildUnitaryMatrix: n [
	"Створює масив масивів, одиничну матрицю порядку n."

	| matrix |
	matrix := self createMatrix: n.
	1 to: n do: [ :i | (matrix at: i) at: i put: 1 ].
	1 to: n - 1 do: [ :i |
		i + 1 to: n do: [ :j |
			(matrix at: i) at: j put: 0.
			(matrix at: j) at: i put: 0 ] ].
	^ matrix
]

{ #category : 'calculation' }
NestedLoops >> createMatrix: n [
	"Будує квадратну матрицю, масив масивів, порядку n (виділяє рам'ять)."

	| matrix |
	matrix := Array new: n.
	1 to: n do: [ :i | matrix at: i put: (Array new: n) ].
	^ matrix
]

{ #category : 'calculation' }
NestedLoops >> economicArrSumming: anArray2D [
	"За заданою квадратною матрицею, двохвимірним масивом anArray2D, будує нову, чиї елементи є сумами
	 відповідних прямокутних ділянок заданої матриці. Індекси (i,j) елемента задають координати лівого
	 нижнього кута ділянки.  Для обчислення нових елементів використано обчислені значення попередніх."

	| n bArray2D |
	n := anArray2D width.
	bArray2D := CTArray2D width: n height: n.
	bArray2D at: n @ 1 put: (anArray2D at: n @ 1 ).
	2 to: n do: [ :i |
		bArray2D atX: n atY: i put: ((bArray2D atX: n atY: i - 1) + (anArray2D atX: n atY: i)) ].
	n - 1 to: 1 by: -1 do: [ :j |
		| s |
		s := 0.
		1 to: n do: [ :i |
			s := s + (anArray2D atX: j atY: i).
			bArray2D atX: j atY: i put: (bArray2D atX: j + 1 atY: i) + s ] ].
	^ bArray2D
]

{ #category : 'calculation' }
NestedLoops >> economicSumming: aMatrix [
	"За заданою квадратною матрицею aMatrix будує нову, чиї елементи є сумами відповідних прямокутних
 ділянок заданої матриці. Індекси (i,j) елемента задають координати лівого нижнього кута ділянки.
 Для обчислення нових елементів використано обчислені значення попередніх."

	| n bMatrix |
	n := aMatrix size.
	bMatrix := self createMatrix: n.
	(bMatrix at: 1) at: n put: ( (aMatrix at: 1) at: n ).
	2 to: n do: [ :i |
		(bMatrix at: i) at: n put: (((bMatrix at: i - 1) at: n) + ((aMatrix at: i) at: n)) ].
	n - 1 to: 1 by: -1 do: [ :j |
		| s |
		s := 0.
		1 to: n do: [ :i |
			s := s + ((aMatrix at: i) at: j).
			(bMatrix at: i) at: j put: ((bMatrix at: i) at: j + 1) + s ] ].
	^ bMatrix
]

{ #category : 'calculation' }
NestedLoops >> fillUnitaryArray2D: n [
	"Створює двохвимірний масив, одиничну матрицю порядку n, послідовним заповненням."

	| matrix curr n2 |
	matrix := CTArray2D width: n height: n.
	curr := 1.
	n2 := n squared.
	[ curr < n2 ] whileTrue: [
		matrix contents at: curr put: 1. curr := curr + 1.
		n timesRepeat: [
			matrix contents at: curr put: 0. curr := curr + 1 ] ].
	matrix contents at: curr put: 1.
	^ matrix
]

{ #category : 'input' }
NestedLoops >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число - розмір матриці'
		   initialAnswer: '2'
		   title: 'Запит') asInteger abs
]

{ #category : 'calculation' }
NestedLoops >> matrixFromSequence: anArray [
	"Заповнює матрицю змійкою значеннями заданої послідовності.
 Використано відображення індексів елемента матриці на індекс елемента послідовності"

	| n matrix k |
	n := anArray size sqrt.
	matrix := self createMatrix: n.
	1 to: n do: [ :j |
		j even
			ifTrue: [ k := j * n + 1.
				1 to: n do: [ :i | (matrix at: i) at: j put: ( anArray at: k - i ) ] ]
			ifFalse: [ k := (j - 1) * n.
				1 to: n do: [ :i | (matrix at: i) at: j put: ( anArray at: k + i ) ] ] ].
	^ matrix
]

{ #category : 'calculation' }
NestedLoops >> moveMaxIn: aMatrix [
" Переставляє рядки і стовпці матриці так, щоб найбільший за абсолютною величиною
 елемент розташувався в лівому верхньому куті."

	| maxValue maxRow maxColumn toSwap unswer |
	maxValue := ((aMatrix at: 1) at: 1) abs.
	maxRow := 1.
	maxColumn := 1.
	aMatrix withIndexDo: [ :row :i |
		row withIndexDo: [ :elem :j |
			elem abs > maxValue ifTrue: [ 
				maxValue := elem abs. maxRow := i. maxColumn := j ]
		] ].
	unswer := aMatrix deepCopy.
	maxRow ~= 1 ifTrue: [ 
		toSwap := unswer at: 1.
		unswer at: 1 put: (unswer at: maxRow).
		unswer at: maxRow put: toSwap ].
	maxColumn ~= 1 ifTrue: [ 
		unswer do: [ :row |
			toSwap := row at: 1.
			row at: 1 put: (row at: maxColumn).
			row at: maxColumn put: toSwap ] ].
	^ unswer
]

{ #category : 'calculation' }
NestedLoops >> moveMaximalIn: anArray [
" Переставляє рядки і стовпці двохвимірного масиву так, щоб найбільший за абсолютною величиною
 елемент розташувався в лівому верхньому куті."

	| maxValue maxRow maxColumn toSwap unswer |
	maxValue := (anArray at: 1 @ 1) abs.
	maxRow := 1.
	maxColumn := 1.
	anArray rowAndColumnValuesDo: [ :row :column :elem |
		elem abs > maxValue ifTrue: [ 
			maxValue := elem abs. maxRow := row. maxColumn := column ]
		].
	unswer := anArray deepCopy.
	maxRow ~= 1 ifTrue: [ 
		toSwap := unswer atRow: 1.
		unswer atRow: 1 put: (unswer atRow: maxRow).
		unswer atRow: maxRow put: toSwap ].
	maxColumn ~= 1 ifTrue: [ 
		toSwap := unswer atColumn: 1.
		unswer atColumn: 1 put: (unswer atColumn: maxColumn).
		unswer atColumn: maxColumn put: toSwap ].
	^ unswer
]

{ #category : 'calculation' }
NestedLoops >> multArray: a by: b [

	| c y |
	a width = b height ifFalse: [ ^ self error: 'Incomartible size of multiplier' ].
	c := CTArray2D width: b width height: a height.
	y := 0.
	a rowsDo: [ :row | y := y + 1.
		1 to: b width do: [ :x |
			| s | s := 0.
			row with: (b atColumn: x) do: [ :aElem :bElem | s := s + (aElem * bElem) ].
			c atColumn: x atRow: y put: s ] ].
	^ c
]

{ #category : 'calculation' }
NestedLoops >> multMatrix: a by: b [

	| aWidth aHeight bWidth bHeight c |
	aWidth := (a at: 1) size.
	aHeight := a size.
	bWidth := (b at: 1) size.
	bHeight := b size.
	aWidth = bHeight ifFalse: [ ^ self error: 'Incomartible size of multiplier' ].
	c := Array new: aHeight.
	1 to: aHeight do: [ :i | c at: i put: (Array new: bWidth) ].
	1 to: aHeight do: [ :i |
		1 to: bWidth do: [ :j |
			| s | s := 0.
			1 to: aWidth do: [ :k | s := s + (((a at: i) at: k) * ((b at: k) at: j)) ].
			(c at: i) at: j put: s ] ].
	^ c
]

{ #category : 'api - running' }
NestedLoops >> multMatrixes [
	"Множить дві задані матриці різними способами. Заради простоти множники створюють програмно"

	| aMatrix bMatrix cMatrix anArray bArray cArray dArray str |
	aMatrix := #((1 2 3) (4 5 6) (7 8 0)).
	bMatrix := #((-16 8 -1) (14 -7 2) (-1 2 -1)).
	anArray := CTArray2D fromArray: aMatrix flattened width: 3.
	bArray := CTArray2D fromArray: { -16/9 . 8/9 . -1/9 . 14/9 . -7/9 . 2/9 . -1/9 . 2/9 . -1/9 } width: 3.
	cMatrix := self multMatrix: aMatrix by: bMatrix.
	cArray := self multArray: anArray by: bArray.
	dArray := CTArray2D fromArray: #(1 2 3 4 5 6 7 8 9 0 1 2) width: 4.
	str := String streamContents: [ :stream |
		stream nextPutAll: '*** Множення матриць:'; cr; cr;
			nextPutAll: ' - Задана квадратна матриця'; cr.
			self printMatrix: aMatrix on: stream.
			stream nextPutAll: ' - Майже обернена матриця'; cr.
			self printMatrix: bMatrix on: stream.
			stream nextPutAll: ' - Добуток заданої та майже оберненої'; cr.
			self printMatrix: cMatrix on: stream.
			stream nextPutAll: ' - Добуток заданої матриці (масиву) та оберненої'; cr.
			cArray printGridOn: stream.
			stream nextPutAll: ' - Задана прямокутна матриця (масив)'; cr.
			dArray printGridOn: stream.
			stream nextPutAll: ' - Добуток прямокутної та транспонованої'; cr.
			(self multArray: dArray by: (self transposeArray2D: dArray)) printGridOn: stream.
			stream nextPutAll: ' - Добуток транспонованої та прямокутної'; cr.
			(self multArray: (self transposeArray2D: dArray) by: dArray) printGridOn: stream
		].
	self showWindowLabeled: 'Обчислення добутку матриць' with: str
]

{ #category : 'printing' }
NestedLoops >> print: anInteger on: aStream width: w [
	"Друкує число anInteger в потік aStream у полі шириною w, ліву частину заповнює пропусками."

	w - anInteger numberOfDigits timesRepeat: [ aStream nextPut: Character space ].
	anInteger printOn: aStream
]

{ #category : 'printing' }
NestedLoops >> printMatrix: aMatrix on: aStream [
"Друкує як прямокутну таблицю матрицю aMatrix, масив масивів, у потік aStream."

aMatrix do: [ :row |
	row do: [ :elem | self print: elem on: aStream width: 6 ].
	aStream cr ]
]

{ #category : 'api - running' }
NestedLoops >> rearrangeMatrix [
	"Знаходить найбільший за абсолютною величиною елемент матриці.
	Переставляє рядки і стовпці матриці так, щоб він опинився на першому
	місці першого рядка. Заради простоти матриці створюють програмно"

	| aMatrix bMatrix anArray bArray str |
	aMatrix := #((1 2 3 4) (0 5 6 1) (2 7 9 8)).
	anArray := CTArray2D fromArray: aMatrix flattened width: 4.
	bMatrix := #((-15 10 14) (11 12 13)).
	bArray := CTArray2D fromArray: bMatrix flattened width: 3.
	str := String streamContents: [ :stream |
		stream nextPutAll: '*** Перебудова заданої матриці:'; cr;
			nextPutAll: ' головний елемент переставляють у лівий верхній кут'; cr; cr;
			nextPutAll: ' - Задані матриці'; cr.
			self printMatrix: aMatrix on: stream.
			stream cr.
			self printMatrix: bMatrix on: stream.
			stream nextPutAll: ' - Перебудовані матриці'; cr.
			self printMatrix: (self moveMaxIn: aMatrix) on: stream.
			stream cr.
			self printMatrix: (self moveMaxIn: bMatrix) on: stream.
			stream nextPutAll: ' - Перебудовані двовимірні масиви'; cr.
			(self moveMaximalIn: anArray) printGridOn: stream.
			stream cr.
			(self moveMaximalIn: bArray) printGridOn: stream ].
	self showWindowLabeled: 'Перебудова матриць' with: str
]

{ #category : 'calculation' }
NestedLoops >> refillTriangleArray2D: n [
	"Створює двохвимірний масив, верхньотрикутну матрицю порядку n."

	| matrix |
	matrix := (CTArray2D width: n height: n) atAllPut: 0.
	n to: 1 by: -1 do: [ :i | 
		1 to: i do: [ :j |
			matrix at: (i + 1 - j) @ j put: i ] ].
	^ matrix
]

{ #category : 'calculation' }
NestedLoops >> refillUnitaryArray2D: n [
	"Створює двохвимірний масив, одиничну матрицю порядку n."

	| matrix |
	matrix := (CTArray2D width: n height: n) atAllPut: 0.
	1 to: n do: [ :i | matrix at: i @ i put: 1 ].
	^ matrix
]

{ #category : 'calculation' }
NestedLoops >> regionsArrSumming: anArray2D [
	"За заданою квадратною матрицею, масивом anArray2D, будує нову, чиї елементи є сумами відповідних
	 прямокутних ділянок заданої матриці. Індекси (i,j) елемента задають координати лівого нижнього кута
	 ділянки. Використано зручний спосіб індексування."

	| n bArray2D |
	n := anArray2D width.
	bArray2D := CTArray2D width: n height: n.
	1 to: n do: [ :i |
		1 to: n do: [ :j |
			| s |
			s := 0.
			1 to: i do: [ :k |
				j to: n do: [ :l |
					s := s + (anArray2D at: l @ k) ] ].
			bArray2D at: j @ i put: s ] ].
	^ bArray2D
]

{ #category : 'calculation' }
NestedLoops >> regionsSumming: aMatrix [
	"За заданою квадратною матрицею aMatrix будує нову, чиї елементи є сумами відповідних прямокутних
 ділянок заданої матриці. Індекси (i,j) елемента задають координати лівого нижнього кута ділянки."

	| n bMatrix |
	n := aMatrix size.
	bMatrix := self createMatrix: n.
	1 to: n do: [ :i |
		1 to: n do: [ :j |
			| s |
			s := 0.
			1 to: i do: [ :k |
				j to: n do: [ :l |
					s := s + ((aMatrix at: k) at: l) ] ].
			(bMatrix at: i) at: j put: s ] ].
	^ bMatrix
]

{ #category : 'calculation' }
NestedLoops >> sequenceToArray2D: anArray [
	"Вкладає послідовність у матрицю змійкою. Використано можливості
	 класу CTArray2D звертатися відразу до цілих рядків."

	| n arr2d |
	n := anArray size sqrt.
	arr2d := CTArray2D fromArray: anArray width: n.
	2 to: n by: 2 do: [ :row | arr2d atRow: row put: (arr2d atRow: row) reversed ].
	^ self transposeArray2D: arr2d
]

{ #category : 'calculation' }
NestedLoops >> sequenceToMatrix: anArray [
	"Вкладає послідовність у матрицю змійкою. Використано відображення
	 індексу елемента послідовності на індекси елемента матриці."

	| n matrix i j step |
	n := anArray size sqrt.
	matrix := self createMatrix: n.
	i := 1.
	j := 1.
	step := 1.
	anArray doWithIndex: [ :each :k | (matrix at: i) at: j put: each.
		k \\ n = 0
			ifTrue: [ j := j + 1. step := step negated ]
			ifFalse: [ i := i + step ] ].
	^ matrix
]

{ #category : 'output' }
NestedLoops >> showWindowLabeled: labelString with: text [
	"Відкриває окреме текстове вікно з об'ємними результатами"

	(SystemWindow labelled: labelString)
		addMorph: (RubScrolledTextMorph new
				 setText: text;
				 font: StandardFonts codeFont;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
]

{ #category : 'api - running' }
NestedLoops >> snakeMatrix [
	"Вкладає 'змійкою' послідовність n^2 чисел у квадратну матрицю nxn.
 Побудову виконано різними способами."

	| sequence matrix1 matrix2 arr2d n str |
	n := self inputNatural.
	sequence := (1 to: n squared) asArray.
	matrix1 := self matrixFromSequence: sequence.
	matrix2 := self sequenceToMatrix: sequence.
	arr2d := self sequenceToArray2D: sequence.
	str := String streamContents: [ :stream |
		stream nextPutAll: '*Заповнення матриці "змійкою" заданими значеннями*'; cr.
		self printMatrix: matrix1 on: stream.
		stream nextPutAll: '*Вкладення "змійкою" послідовності в матрицю*'; cr.
		self printMatrix: matrix2 on: stream.
		stream nextPutAll: '*Вкладення послідовності в двовимірний масив, побудова змійки*'; cr.
		arr2d printGridOn: stream ].
	self showWindowLabeled: 'Матриця, заповнена змійкою' with: str
]

{ #category : 'api - running' }
NestedLoops >> summingMatrix [
	"Будує квадратну матрицю, чиї елементи є сумами відповідних прямокутних ділянок заданої матриці.
 Індекси (i,j) елемента задають координати лівого нижнього кута ділянки.
 'Задану матрицю' будуємо одним з відомих тут способів."

	| n aMatrix bMatrix cMatrix anArray bArray cArray str |
	n := self inputNatural.
	aMatrix := self sequenceToMatrix: (1 to: n squared) asArray.
	anArray := self sequenceToArray2D: (1 to: n squared) asArray.
	bMatrix := self regionsSumming: aMatrix.
	cMatrix := self economicSumming: aMatrix.
	bArray := self regionsArrSumming: anArray.
	cArray := self economicArrSumming: anArray.
	str := String streamContents: [ :stream |
		stream nextPutAll: '*** Побудова квадратної матриці,'; cr;
			nextPutAll: ' чиї елементи є сумами елементів іншої матриці'; cr; cr;
			nextPutAll: ' - Задана матриця'; cr.
			self printMatrix: aMatrix on: stream.
			stream nextPutAll: ' - Прямолінійне додавання матриці'; cr.
			self printMatrix: bMatrix on: stream.
			stream nextPutAll: ' - Економне додавання матриці'; cr.
			self printMatrix: cMatrix on: stream.
			stream nextPutAll: ' - Прямолінійне додавання двовимірного масиву'; cr.
			bArray printGridOn: stream.
			stream nextPutAll: ' - Економне додавання двовимірного масиву'; cr.
			cArray printGridOn: stream ].
	self showWindowLabeled: 'Додавання елементів ділянки матриці' with: str
]

{ #category : 'calculation' }
NestedLoops >> transposeArray2D: anArray2D [
	"Будує транспоновану матрицю"

	| trArray2D |
	trArray2D := CTArray2D width: anArray2D height height: anArray2D width.
	1 to: anArray2D height do: [ :i |
		trArray2D atColumn: i put: (anArray2D atRow: i) ].
	^ trArray2D
]

{ #category : 'api - running' }
NestedLoops >> triangleMatrix [
	"Будує верхньотрикутну квадратну матрицю nxn. На побічній діагоналі та паралельних до неї
 розташовано постійні величини. Побудову виконано різними способами."

	| matrix arr2d n str |
	n := self inputNatural.
	matrix := self buildTriangleMatrix: n.
	arr2d := self refillTriangleArray2D: n.
	str := String streamContents: [ :stream |
		stream nextPutAll: '*Побудова трикутної матриці заданого розміру*'; cr.
		self printMatrix: matrix on: stream.
		stream nextPutAll: '*Побудова трикутної матриці в двовимірному масиві*'; cr.
		arr2d printGridOn: stream ].
	self showWindowLabeled: 'Трикутна матриця' with: str
]

{ #category : 'api - running' }
NestedLoops >> unitaryMatrix [
"Задано натуральне n. Побудувати і надрукувати одиничну матрицю n-го порядку.
 Задачу розв'язано різними способами: побудовано масив масивів і екземпляри CTArray2D."
| n matrix arr2Dbuild arr2Dfill arr2Drefill |
n := self inputNatural.
matrix := self buildUnitaryMatrix: n.
arr2Dbuild := self buildUnitaryArray2D: n.
arr2Dfill := self fillUnitaryArray2D: n.
arr2Drefill := self refillUnitaryArray2D: n.
self showWindowLabeled: 'Одинична матриця' with: 
	( String streamContents: [ :stream |
		stream nextPutAll: 'Побудова одиничної матриці заданого розміру (за структурою)'; cr.
		self printMatrix: matrix on: stream.
		stream cr; nextPutAll: 'Побудова двохвимірного масиву табуляцією (з перевірками)'; cr.
		arr2Dbuild printGridOn: stream.
		stream cr; nextPutAll: 'Побудова двохвимірного масиву заповненням пам''яті'; cr.
		arr2Dfill printGridOn: stream.
		stream cr.
		arr2Drefill printGridOn: stream ] )
]
