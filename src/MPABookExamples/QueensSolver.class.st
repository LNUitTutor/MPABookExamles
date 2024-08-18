"
Екземпляр класу вміє розв'язувати задачу про 8 ферзів за допомогою двох різних алгоритмів.
Розділ 11 Алгоритм з поверненнями
"
Class {
	#name : 'QueensSolver',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter11',
	#package : 'MPABookExamples',
	#tag : 'Chapter11'
}

{ #category : 'api - running' }
QueensSolver class >> procedure [
	<script>

	| inst n queens success str |
	inst := self new.
	n := inst inputNatural.
	queens := inst getInitialArray: n.
	success := inst tryPut: 1 into: queens.
	str := String streamContents: [ :stream |
		       stream
			       nextPutAll: 'Введено розмір шахівниці: ';
			       print: n; cr; cr.
		       success
			       ifFalse: [ stream nextPutAll: 'Розташування не існує'; cr ]
			       ifTrue: [  stream
					       nextPutAll: '     Знайдено розташування'; cr;
					       nextPutAll: '---------------------------------'; cr; cr;
					       nextPutAll: (inst stringRepresentation: queens); cr; cr;
					       nextPutAll: (inst matrixRepresentation: queens); cr ] ].
	inst showWindowLabeled: 'Задача про вісім ферзів' with: str
]

{ #category : 'procedural' }
QueensSolver >> getInitialArray: n [
	"Генерує початкове розташування ферзів: усі стоять перед шахівницею"

	| arr |
	arr := Array new: n.
	arr atAllPut: 0.
	^ arr
]

{ #category : 'input' }
QueensSolver >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число - розмір матриці'
		   initialAnswer: '2'
		   title: 'Запит') asInteger abs
]

{ #category : 'procedural' }
QueensSolver >> isSafe: queens with: k [
	"Перевіряє, чи ферзь у вертикалі k не загрожує попереднім"

	k - 1 to: 1 by: -1 do: [ :i |
		((queens at: i) = (queens at: k) or: [
		 (i - (queens at: i)) = ( k - (queens at: k)) or: [ 
		 (i + (queens at: i)) = ( k + (queens at: k)) ] ]
		) ifTrue: [ ^ false ] ].
	^ true
]

{ #category : 'procedural' }
QueensSolver >> matrixRepresentation: queens [

	| n board |
	n := queens size.
	board := (Array new: n).
	1 to: n do: [ :i | board at: i put: ((Array new: n) atAllPut: $.) ].
	queens withIndexDo: [ :q :i | (board at: q) at: i put: $Q ].
	^String streamContents: [ :stream | 
		n to: 1 by: -1 do: [ :i |
			stream print: i; nextPutAll: ' |'.
			(board at: i) do: [ :c | stream nextPut: Character space; nextPut: c ].
			stream cr ].
		stream nextPutAll: '   '. n timesRepeat: [ stream nextPutAll: '--' ].
		stream cr; nextPutAll: '   '; nextPutAll: (' a b c d e f g h i' copyFrom: 1 to: n * 2); cr ]
]

{ #category : 'output' }
QueensSolver >> showWindowLabeled: labelString with: text [
	"Відкриває окреме текстове вікно з об'ємними результатами"

	(SystemWindow labelled: labelString)
		addMorph: (RubScrolledTextMorph new
				 setText: text;
				 font: StandardFonts codeFont;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
]

{ #category : 'procedural' }
QueensSolver >> stringRepresentation: queens [
	"Будує зображення розв'язку у вигляді послідовності клітинок шахівниці"

	^ Character space join:
		  (('abcdefghi' copyFrom: 1 to: queens size) asArray withIndexCollect: [ :c :i |
			   String
				   with: Character space
				   with: c
				   with: (queens at: i) asCharacterDigit ])
]

{ #category : 'procedural' }
QueensSolver >> tryPut: k into: queens [
	"Намагається розташувати ферзь у k-ій вертикалі"

	| success n |
	success := false.
	n := queens size.
	queens at: k put: 0.
	[success or: [ (queens at: k) >= n ]] whileFalse: [ 
		queens at: k put: (queens at: k) + 1.
		(self isSafe: queens with: k) ifTrue: [ 
			success := k = n ifTrue: [ true ]
				ifFalse: [ self tryPut: k + 1 into: queens ] ] ].
	^success
]
