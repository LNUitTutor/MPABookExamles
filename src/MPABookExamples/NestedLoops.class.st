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

{ #category : 'calculation' }
NestedLoops >> transposeArray2D: anArray2D [
	"Будує транспоновану матрицю"

	| trArray2D |
	trArray2D := CTNewArray2D width: anArray2D height height: anArray2D width.
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
