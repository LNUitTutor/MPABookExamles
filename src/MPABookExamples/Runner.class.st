"
Клвс використовують для запуску прикалдів розділу 10 Рекурсія
"
Class {
	#name : 'Runner',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'input' }
Runner >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число'
		   initialAnswer: '1'
		   title: 'Запит') asInteger abs
]

{ #category : 'api - running' }
Runner >> quickSortArray [

	| arr stream |
	stream := String new writeStream.
	arr := Sorter example1.
	stream nextPutAll: 'Початковий масив'; cr.
	arr printOn: stream.
	arr stableQuickSort.
	stream nextPutAll: 'Результати швидкого стабільного сортування'; cr.
	arr printOn: stream.
	stream nextPutAll: 'Результати швидкого сортування'; cr.
	Sorter example1 quickSort printOn: stream.
	self showWindowLabeled: 'Впорядкування масиву за зростанням' with: stream contents
]

{ #category : 'output' }
Runner >> showWindowLabeled: labelString with: text [
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
Runner >> solveHanoiTower [

	| n solver stream |
	stream := String new writeStream.
	solver := HanoiSolwer new.
	n := self inputNatural.
	stream
		nextPutAll: 'Висота вежі: ';
		print: n;
		cr.
	solver
		solve: n;
		printSolutionOn: stream.
	self
		showWindowLabeled: 'Розв''язування задачі про Ханойські вежі'
		with: stream contents
]

{ #category : 'api - running' }
Runner >> traverseTree [

	| tree sum prs stream |
	stream := String new writeStream.
	tree := Tree example1.
	prs := tree preorderSum.
	sum := tree sum.
	stream
		nextPutAll: 'Задане дерево:'; cr;
		print: tree; cr;
		nextPutAll: ' preorder sum = ';
		print: prs; cr;
		nextPutAll: '  economy sum = ';
		print: sum; cr.
	self showWindowLabeled: 'Обхід двійкового дерева' with: stream contents
]
