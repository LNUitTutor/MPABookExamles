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
NestedLoops >> buildUnitaryArray2D: n [
	"Створює масив масивів, одиничну матрицю порядку n."

	^ CTArray2D width: n height: n tabulate: [ :i :j | (i = j) asInteger ]
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
	"Створює масив масивів, одиничну матрицю порядку n."

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
NestedLoops >> unitaryMatrix [
"Задано натуральне n. Побудувати і надрукувати одиничну матрицю n-го порядку.
 Задачу розв'язано різними способами: побудовано масив масивів і екземпляри CTArray2D."
| n matrix arr2Dbuild arr2Dfill |
n := self inputNatural.
matrix := self buildUnitaryMatrix: n.
arr2Dbuild := self buildUnitaryArray2D: n.
arr2Dfill := self fillUnitaryArray2D: n.
self showWindowLabeled: 'Одинична матриця' with: 
	( String streamContents: [ :stream |
		stream nextPutAll: 'Побудова одиничної матриці заданого розміру (за структурою)'; cr.
		self printMatrix: matrix on: stream.
		stream cr; cr; nextPutAll: 'Побудова двохвимірного масиву табуляцією (з перевірками)'; cr.
		arr2Dbuild printGridOn: stream.
		stream cr; cr; nextPutAll: 'Побудова двохвимірного масиву заповненням пам''яті'; cr.
		arr2Dfill printGridOn: stream ] )
]
