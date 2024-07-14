"
Реалізація алгоритмів розділу 1. Цілочислова арифметика
"
Class {
	#name : 'IntegerArithmetic',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter01',
	#package : 'MPABookExamples',
	#tag : 'Chapter01'
}

{ #category : 'as yet unclassified' }
IntegerArithmetic class >> runTasks [

	<script>
	| answer |
	answer := UIManager default
		          chooseFrom:
			          #( 'Середнє арифметичне цифр' 'Чи є паліндром'
			             'Перевірка гіпотези Безу' 'Завершити' )
		          values:
		          #( digitsAverage isPalindrome checkBezuHypothesis
		             quit )
		          lines: #( 3 )
		          title: 'Оберіть задачу'.
	answer == #quit ifFalse: [
		self new perform: answer.
		self runTasks ]
]

{ #category : 'api - running' }
IntegerArithmetic >> checkBezuHypothesis [
	"Перевіряє гіпотезу Безу для всіх цілих з проміжку [a; b].
 До кожного з чисел застосовує не більше за k перетворень."

	| a b k inpt text res |
	inpt := self inputThreeNaturals.
	a := inpt at: 1.
	b := inpt at: 2.
	k := inpt at: 3.
	a > b ifTrue: [ ^ self confirmAbout:
		'Введено неправильні межі проміжка [' , a printString , '; ', b printString , ']' ].
	text := WriteStream with: (String new).
	a to: b do: [ :aNumber |
		res := self checkHipothesisFor: aNumber untilTimes: k.
		text
			nextPutAll: 'Для числа '; print: aNumber;
			nextPutAll: ' за '; print: (res at: 2);
			nextPutAll: ' крок(и) '.
		(res at: 1)
			ifTrue: [ text
					nextPutAll: 'отримано паліндром ';
					print: (res at: 3); cr ]
			ifFalse: [ text
					nextPutAll: 'гіпотеза не виконується'; cr ] ].
	self showWindowLabeled: 'Результати перевірки гіпотези Безу' with: text contents
]

{ #category : 'calculation' }
IntegerArithmetic >> checkHipothesisFor: aNumber untilTimes: k [
	"Перевіряє гіпотезу Безу для заданого цілого. Виконує не більше за k перетворень."

	| direct reversed counter |
	direct := aNumber.
	reversed := 0.
	counter := 0.
	[ 	direct := direct + reversed.
	   reversed := self reverseNumber: direct.
	   counter := counter + 1.
	   reversed ~= direct and: [ counter <= k ] ] whileTrue.
   ^ { reversed = direct . counter . reversed }
]

{ #category : 'output' }
IntegerArithmetic >> confirmAbout: aString [
	"Повідомляє результат у модальному вікні, закрити його можна довільною кнопкою"

	UIManager default confirm: aString label: 'Результати обчислень'
]

{ #category : 'api - running' }
IntegerArithmetic >> digitsAverage [
	"Парадний метод обчислення середнього арифметичного цифр заданого числа"

	| givenNumber result pharoResult |
	givenNumber := self inputNatural.
	result := self digitsAverageOf: givenNumber.
	pharoResult := self pharoDigitsAverageOf: givenNumber.
	self informAbout:
	   '*** Обчислення середнього арифметичного цифр заданого числа'
		, String cr, 'задане число = ' , givenNumber printString
		, '   середнє = '	, result printString
		, String cr, '  середнє засобами Pharo = ', pharoResult printString
]

{ #category : 'calculation' }
IntegerArithmetic >> digitsAverageOf: aNatural [
	"Обчислює середнє арифметичне цифр натурального числа"

	| restOfDigits rightmostDigit sum digitsQuantity |
	restOfDigits := aNatural.
	sum := 0.
	digitsQuantity := 0.
	[ restOfDigits > 0 ] whileTrue: [
		rightmostDigit := restOfDigits \\ 10.
		sum := sum + rightmostDigit.
		digitsQuantity := digitsQuantity + 1.
		restOfDigits := restOfDigits // 10 ].
	^ sum / digitsQuantity
]

{ #category : 'output' }
IntegerArithmetic >> informAbout: aString [
	"Повідомляє результат у інформційному вікні, що закривається автоматично"

	UIManager default inform: aString
]

{ #category : 'input' }
IntegerArithmetic >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число'
		   initialAnswer: '1'
		   title: 'Запит') asInteger abs
]

{ #category : 'input' }
IntegerArithmetic >> inputThreeNaturals [
	"Відкриває вікно діалогу для введення трьох цілих чисел. Не виконує ніяких перевірок"

	^ ((UIManager default
		   request: 'Введіть три натуральних числа, відокремлених пропуском: a, b, k, a<=b'
		   initialAnswer: '10 20 5'
		   title: 'Запит') splitOn: Character space) collect: [ :each | each asInteger abs]
]

{ #category : 'api - running' }
IntegerArithmetic >> isPalindrome [
	"Парадний метод для перевірки, чи задане число паліндром"

	| givenNumber result pharoResult |
	givenNumber := self inputNatural.
	result := self isPalindrome: givenNumber.
	pharoResult := givenNumber printString reversed asInteger = givenNumber.
	self informAbout:
	   '*** Перевірка, чи задане число одинаково читається зліва направо і навпаки.'
		, String cr, 'задане число = ' , givenNumber printString
		, (result ifTrue: [ ' - паліндром' ] ifFalse: [ ' - не паліндром' ] )
		, String cr, '  перевірка засобами Pharo = ', pharoResult printString
]

{ #category : 'calculation' }
IntegerArithmetic >> isPalindrome: aNatural [
	"Перевіряє, чи задане число - паліндром"

	| reversedNumber restOfDigits rightmostDigit |
	reversedNumber := 0.
	restOfDigits := aNatural.
	[ restOfDigits > 0 ] whileTrue: [
		rightmostDigit := restOfDigits \\ 10.
		reversedNumber := reversedNumber * 10 + rightmostDigit.
		restOfDigits := restOfDigits // 10 ].
	^ reversedNumber = aNatural
]

{ #category : 'calculation' }
IntegerArithmetic >> pharoDigitsAverageOf: aNatural [
	"Обчислює середнє арифметичне цифр натурального числа вбудованими засобами"

	^ aNatural digitSum / aNatural decimalDigitLength
]

{ #category : 'calculation' }
IntegerArithmetic >> reverseNumber: anInteger [
	"Будує натуральне число, чий десятковий запис є оберненим записом заданого числа"

	| result restOfDigits |
	result := 0.
	restOfDigits := anInteger.
	[ restOfDigits > 0 ] whileTrue: [
		result := result * 10 + (restOfDigits \\ 10).
		restOfDigits := restOfDigits // 10 ].
	^ result 
]

{ #category : 'output' }
IntegerArithmetic >> showWindowLabeled: labelString with: text [
	"Відкриває окреме текстове вікно з об'ємними результатами"

	(SystemWindow labelled: labelString)
		addMorph: (RubScrolledTextMorph new
				 setText: text;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
]
