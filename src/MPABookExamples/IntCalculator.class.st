"
Розділ 9 Покрокова розробка програм
- Обчислення великого степеня числа 2
- Обчислення великого факторіала
"
Class {
	#name : 'IntCalculator',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter09',
	#package : 'MPABookExamples',
	#tag : 'Chapter09'
}

{ #category : 'accessing - ui' }
IntCalculator class >> runTasks [

	<script>
	| answer |
	answer := UIManager default
		          chooseFrom:
			          #( 'Степінь числа 2'
							 'Факторіал числа' )
		          values:
		          #( calculatePower calculateFactorial )
		          lines: #()
		          title: 'Оберіть задачу'.
	answer ifNotNil: [
		self new perform: answer.
		self runTasks ]
]

{ #category : 'calculation' }
IntCalculator >> calcFactorial: n [
	"Обчислення великого факторіала"

	| x |
	x := LongInteger new set: 1.
	2 to: n do: [ :i | x multBy: i ].
	^ x
]

{ #category : 'calculation' }
IntCalculator >> calcPower: n [
	"Обчислення великого степеня числа 2"

	| x |
	x := LongInteger new set: 1.
	n timesRepeat: [ x multByTwo ].
	^ x
]

{ #category : 'api - running' }
IntCalculator >> calculateFactorial [

	| n f |
	n := self inputNatural.
	f := self calcFactorial: n.
	self showWindowLabeled: 'Обчислення великого факторіала'
		with: ( String streamContents: [ :stream |
			stream nextPutAll: '*** Обчислення власними засобами'; cr; cr;
				print: n; 	nextPutAll: '! = '; print: f; cr; cr;
				nextPutAll: '*** Обчислення вбудованими засобами'; cr; cr;
				print: n; nextPutAll: ' factorial = '; print: n factorial; cr ] )
]

{ #category : 'api - running' }
IntCalculator >> calculatePower [

	| n pow |
	n := self inputNatural.
	pow := self calcPower: n.
	self showWindowLabeled: 'Обчислення великого степеня числа 2'
		with: ( String streamContents: [ :stream |
			stream nextPutAll: '*** Обчислення власними засобами'; cr; cr;
				nextPutAll: '        2 в степені '; print: n;
				nextPutAll: ' = '; print: pow; cr; cr;
				nextPutAll: '*** Обчислення вбудованими засобами'; cr; cr;
				nextPutAll: ' 2 raisedToInteger: '; print: n;
				nextPutAll: ' = '; print: (2 raisedToInteger: n); cr ] )
]

{ #category : 'input' }
IntCalculator >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число'
		   initialAnswer: '100'
		   title: 'Запит') asInteger abs
]

{ #category : 'output' }
IntCalculator >> showWindowLabeled: labelString with: text [
	"Відкриває окреме текстове вікно з об'ємними результатами"

	(SystemWindow labelled: labelString)
		addMorph: (RubScrolledTextMorph new
				 setText: text;
				 font: StandardFonts codeFont;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
]
