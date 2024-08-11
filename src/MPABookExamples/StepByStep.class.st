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

{ #category : 'accessing - ui' }
StepByStep class >> runTasks [

	<script>
	| answer |
	answer := UIManager default
		          chooseFrom:
			          #( 'Середнє квадратичне послідовності чисел'
							 'Середнє арифметичне послідовності, що закінчується нулем'
							 'Таблиця значень тригонометричних функцій'
							 'Зростаюча послідовність, обмежена заданим значенням'
			             'Послідовність Фібоначчі до k-го члена'
							 'Послідовності середніх арифметичних і геометричних')
		          values:
		          #( quadraticMean average buildTable succession fibonacci averageVSgeometricMean )
		          lines: #()
		          title: 'Оберіть задачу'.
	answer ifNotNil: [
		self new perform: answer.
		self runTasks ]
]

{ #category : 'calculation' }
StepByStep >> aveVSgeoOf: a and: b with: eps [
	"Будує дві пов'язані послідовності з середніх арифметичних і середніх геометричних
	 двох заданих чисел і їхніх середніх. Повертає форматований рядок."

	| stream u v k |
	stream := WriteStream on: String new.
	stream
		nextPutAll:
			'*Побудова послідовностей середніх арифметичних і геометричних*'; cr; cr;
		nextPutAll: '  k      x_k         y_k'; cr;
		nextPutAll: '----------------------------'; cr.
	u := a.
	v := b.
	k := 1.
	self print: k on: stream width: 3;
		print: u on: stream width: 12 digits: 6;
		print: v on: stream width: 12 digits: 6.
	stream cr.
	[ (u - v) abs >= eps ] whileTrue: [ | p q |
		k := k + 1.
		p := u.
		q := v.
		u := (p + q) / 2.0.
		v := (p * q) sqrt.
		self print: k on: stream width: 3;
			print: u on: stream width: 12 digits: 6;
			print: v on: stream width: 12 digits: 6.
		stream cr ].
	^ stream contents
]

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
StepByStep >> averageVSgeometricMean [
	"Будує дві послідовності: x_1 = a, y_1 = b;
	 x_k = (x_k-1 + y_k-1) / 2, yx_k = sqrt(x_k-1 * y_k-1), k = 2, 3, ...,
	 до досягнення |x_k - y_k| < eps"

	| givenNumbers result |
	givenNumbers := self inputThreeFloats.
	result := self
		          aveVSgeoOf: (givenNumbers at: 1)
		          and: (givenNumbers at: 2)
		          with: (givenNumbers at: 3).
	self showWindowLabeled: 'Числові послідовності середніх' with: result
]

{ #category : 'api - running' }
StepByStep >> buildTable [
	"Будує таблицю значень двох функцій, виводить її  вокремому вікні"

	self
		showWindowLabeled: 'Таблиця значень функцій sin x, cos x'
		with: (self tabulateFor: 12)
]

{ #category : 'api - running' }
StepByStep >> fibonacci [
	"Будує послідовність Фібоначчі від f_0 до f_k, де k - задане число."

	| givenM result pharoResult |
	givenM := self inputNatural.
	result := self fibonacciUpTo: givenM.
	self showWindowLabeled: 'Послідовність Фібоначчі' with: result.
	pharoResult := self pharoFibonacciUpTo: givenM.
	self showWindowLabeled: 'Послідовність Фібоначчі (Pharo)' with: pharoResult
]

{ #category : 'calculation' }
StepByStep >> fibonacciUpTo: k [
	"Обчислює члени послідовності Фібоначчі від 0-го по k-й включно, k >=2.
    Повертає рядок з результатами."

	| stream f_n f_n1 f_n2 |
	stream := WriteStream on: String new.
	stream
		nextPutAll: '*Побудова послідовності чисел Фібоначчі*'; cr; cr;
		nextPutAll: 'номер останнього: '; print: k; cr.
	f_n1 := 1.
	f_n2 := 1.
	stream
		nextPutAll: 'f(0) = '; print: f_n2; cr; nextPutAll: 'f(1) = '; print: f_n1; cr.
	2 to: k do: [ :n |
		f_n := f_n1 + f_n2.
		f_n2 := f_n1.
		f_n1 := f_n.
		stream
			nextPutAll: 'f('; 	print: n; nextPutAll: ') = '; print: f_n; cr. ].
	^ stream contents
]

{ #category : 'output' }
StepByStep >> informAbout: aString [
	"Повідомляє результат у інформаційному вікні діалогу"

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
StepByStep >> inputThreeFloats [
	"Відкриває вікно діалогу для введення трьох дійсних чисел. Не виконує ніяких перевірок"

	| stream a b eps |
	stream := (UIManager default
		   request: 'Введіть три дійсних числа, відокремлених пропуском: a, b, eps, a<=b'
		   initialAnswer: '1 100 1e-5'
		   title: 'Запит') readStream.
	a := Float readFrom: stream. stream next.
	b := Float readFrom: stream. stream next.
	eps := Float readFrom: stream.
	^ { a . b. eps }
]

{ #category : 'calculation' }
StepByStep >> pharoFibonacciUpTo: k [
	"Обчислює члени послідовності Фібоначчі від 0-го по k-й включно, k >=2 за допомогою генератора.
    Повертає рядок з результатами."

	| stream generator |
	stream := WriteStream on: String new.
	stream
		nextPutAll: '*Побудова послідовності чисел Фібоначчі засобами Pharo*'; cr; cr;
		nextPutAll: 'номер останнього: '; print: k; cr.
	generator := GeneratorTest new fibonacciSequence.
	0 to: k do: [ :n |
		stream
			nextPutAll: 'f('; 	print: n; nextPutAll: ') = '; print: generator next; cr. ].
	^ stream contents
]

{ #category : 'output' }
StepByStep >> print: anInteger on: aStream width: w [
	"Друкує число anInteger в потік aStream у полі шириною w, ліву частину заповнює пропусками."

	w - anInteger numberOfDigits timesRepeat: [ aStream nextPut: Character space ].
	anInteger printOn: aStream
]

{ #category : 'output' }
StepByStep >> print: aFloat on: aStream width: w digits: d [
	"Друкує число aFloat в потік aStream у полі шириною w з d значащими цифрами"

	aFloat = 0.0
		ifTrue: [
			w - d - 2 timesRepeat: [ aStream nextPut: Character space ].
			aStream nextPutAll: '0.'.
			d timesRepeat: [ aStream nextPut: $0 ] ]
		ifFalse: [
			w - d - 3 timesRepeat: [ aStream nextPut: Character space ].
			aStream nextPut: (aFloat < 0
					 ifTrue: [ $- ]
					 ifFalse: [ Character space ]).
			aFloat abs absPrintOn: aStream base: 10 digitCount: d ]
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

{ #category : 'api - running' }
StepByStep >> succession [
	"Будує зростаючу послідовність, знаходить перший член, що перевищує задане число."

	| givenM result |
	givenM := self inputNatural.
	result := self successionUpTo: givenM.
	self showWindowLabeled: 'Числова послідовність' with: result
]

{ #category : 'calculation' }
StepByStep >> successionUpTo: m [
	"Обчислює члени послідовності a_0 = 1; a_k = a_k-1 / k + 0.2 * k + 1, k = 1, 2, ...,
 щоб досягти a_k > m. Повертає рядок з результатами."

	| stream a k |
	stream := WriteStream on: String new.
	stream
		nextPutAll: '*Побудова зростаючої числової послідовності*'; cr; cr;
		nextPutAll: 'межа: '; print: m; cr.
	k := 0.
	a := 1.0.
	stream
		nextPutAll: 'a('; 	print: k; nextPutAll: ') = '; print: a; cr.
	[ a <= m ] whileTrue: [ 
		k := k + 1.
		a := a / k + (0.2 * k) + 0.1.
		stream
			nextPutAll: 'a('; 	print: k; nextPutAll: ') = '; print: a; cr. ].
	stream
		nextPutAll: 'Знайдений номер = '; print: k; cr.
	^ stream contents
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
