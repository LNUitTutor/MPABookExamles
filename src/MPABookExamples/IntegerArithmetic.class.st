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
			          #( 'Середнє арифметичне цифр' 'Чи є паліндром' 'Перевірка гіпотези Безу'
			             'Надрукувати в (2) і (16) системі' 'Розклад на прості множники' )
		          values:
		          #( digitsAverage isPalindrome checkBezuHypothesis printWithNewBase primeFactorization )
		          lines: #()
		          title: 'Оберіть задачу'.
	answer ifNotNil: [
		self new perform: answer.
		self runTasks ]
]

{ #category : 'calculation' }
IntegerArithmetic >> binaryStrOf: aNumber [
	"Будує рядок - двійковий запис заданого числа"

	| givenNumber binaryArr k |
	givenNumber := aNumber.
	k := givenNumber numberOfDigitsInBase: 2.
	binaryArr := Array new: k.
	[ givenNumber > 0 ] whileTrue: [
		(givenNumber \\ 2) even
			ifTrue: [ binaryArr at: k put: $0 ]
			ifFalse: [ binaryArr at: k put: $1 ].
		givenNumber := givenNumber // 2.
		k := k - 1 ].
	^ String withAll: binaryArr
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

{ #category : 'calculation' }
IntegerArithmetic >> hexadecimalStrOf: aNumber [
	"Будує рядок - двійковий запис заданого числа"

	| givenNumber hexaArr k |
	givenNumber := aNumber.
	k := givenNumber numberOfDigitsInBase: 16.
	hexaArr := Array new: k.
	[ givenNumber > 0 ] whileTrue: [
		hexaArr at: k put: (Character digitValue: givenNumber \\ 16).
		givenNumber := givenNumber // 16.
		k := k - 1 ].
	^ String withAll: hexaArr
]

{ #category : 'output' }
IntegerArithmetic >> informAbout: aString [
	"Повідомляє результат у інформаційному вікні, що закривається автоматично"

	UIManager default message: aString title: 'Результати обчислень'
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
IntegerArithmetic >> primeBetterDecompositionOf: anInteger [
	"Дещо кращий розклад на прості множники: перебираємо дільники, перевіряємо, чи є вони простими числами"

	| decomposition |
	decomposition := WriteStream with: Array new.
	2 to: anInteger do: [ :divider |
		| divTimes |
		(anInteger \\ divider = 0 and: [ divider isPrime ])
		 ifTrue: [
			divTimes := divider.
			[ anInteger \\ divTimes = 0 ] whileTrue: [
				decomposition nextPut: divider.
				divTimes := divTimes * divider ] ] ].
	^ decomposition contents
]

{ #category : 'calculation' }
IntegerArithmetic >> primeDecompositionOf: anInteger [
	"Прямолінійний розклад на прості множники: перебираємо прості числа, перевіряємо, чи є вони дільниками"

	| decomposition |
	decomposition := WriteStream with: Array new.
	2 to: anInteger do: [ :divider |
		| divTimes |
		divider isPrime ifTrue: [
			divTimes := divider.
			[ anInteger \\ divTimes = 0 ] whileTrue: [
				decomposition nextPut: divider.
				divTimes := divTimes * divider ] ] ].
	^ decomposition contents
]

{ #category : 'api - running' }
IntegerArithmetic >> primeFactorization [
	"Різними способами розкладає задане число на прості множники"

	| givenNumber decomp1 decomp2 decomp pharoDecomp text t1 t2 t pt |
	givenNumber := self inputNatural.
	t1 := [decomp1 := self primeDecompositionOf: givenNumber] millisecondsToRun.
	t2 := [decomp2 := self primeBetterDecompositionOf: givenNumber] millisecondsToRun.
	t := [decomp := self primeFactorsOf: givenNumber] millisecondsToRun.
	pt := [pharoDecomp := givenNumber primeFactors] millisecondsToRun.

	text := WriteStream with: String new.
	text nextPutAll: '*** Розклад натурального числа на прості множники'; cr;
		nextPutAll: 'задане число = ' ; print: givenNumber; cr;
		nextPutAll: 'розклад "в лоб" '; print: decomp1;  nextPutAll: ' тривав (mSec) '; print: t1; cr;
		nextPutAll: 'покращений розклад '; print: decomp2;  nextPutAll: ' тривав (mSec) '; print: t2; cr;
		nextPutAll: 'оптимальний розклад '; print: decomp;  nextPutAll: ' тривав (mSec) '; print: t; cr;
		nextPutAll: 'розклад засобами Pharo: '; print: pharoDecomp;  nextPutAll: ' тривав (mSec) '; print: pt.
	self showWindowLabeled: 'Розклад на прості множники' with: text contents
]

{ #category : 'calculation' }
IntegerArithmetic >> primeFactorsOf: anInteger [
	"Розклад на прості множники: перебираємо дільники, вилучаємо з числа, перевірка на простоту - зайва"

	| decomposition givenNumber divider |
	decomposition := WriteStream with: Array new.
	givenNumber := anInteger.
	divider := 2.
	[ givenNumber > 1 ] whileTrue: [
		givenNumber \\ divider = 0
			ifTrue: [
				decomposition nextPut: divider.
				givenNumber := givenNumber // divider ]
			ifFalse: [ divider := divider + 1 ] ].
	^ decomposition contents
]

{ #category : 'api - running' }
IntegerArithmetic >> printWithNewBase [
	"Будує різними способами зображення заданого числа у (2) і (16) системах числення"

	| givenNumber binNum binStr hexStr generalResult pharoResult text |
	givenNumber := self inputNatural.
	binNum := self pseudoBinaryOf: givenNumber.
	binStr := self binaryStrOf: givenNumber.
	hexStr := self hexadecimalStrOf: givenNumber.
	pharoResult := (givenNumber printStringBase: 2), '  ', (givenNumber printStringBase: 16).
	generalResult := (self recordStrOf: givenNumber withBase: 2), '  ',
		(self recordStrOf: givenNumber withBase: 16).
	"self informAbout:
		'*** Запис заданого числа у (2) та (16) системах числення'
		, String cr , 'задане число = ' , givenNumber printString
		, '  двійковий аналог = ' , binNum printString , String cr
		, '  двійковий рядок = ' , binStr, String cr
		, '  шістнадцятковий рядок = ' , hexStr, String cr
		, ' загальний метод: ', generalResult, String cr
		, '    засоби Pharo: ', pharoResult"
	text := WriteStream with: String new.
	text nextPutAll: '*** Запис заданого числа у (2) та (16) системах числення'; cr;
		nextPutAll: 'задане число = ' ; print: givenNumber; cr;
		nextPutAll: 'двійковий аналог = '; print: binNum; cr;
		nextPutAll: 'двійковий рядок = '; nextPutAll: binStr; cr;
		nextPutAll: 'шістнадцятковий рядок = ';nextPutAll: hexStr; cr;
		nextPutAll: 'загальний метод: ';nextPutAll: generalResult; cr;
		nextPutAll: 'засоби Pharo: '; nextPutAll: pharoResult.
	self showWindowLabeled: 'Запис числа різними засобами' with: text contents
]

{ #category : 'calculation' }
IntegerArithmetic >> pseudoBinaryOf: aNumber [
	"Імітує двійковий запис заданого числа: будує нове ціле, до запису якого входять лише 0 і 1"

	| givenNumber binaryNumber powerOf10 |
	givenNumber := aNumber.
	binaryNumber := 0.
	powerOf10 := 1.
	[ givenNumber > 0 ] whileTrue: [
		binaryNumber := binaryNumber + (givenNumber \\ 2 * powerOf10).
		givenNumber := givenNumber // 2.
		powerOf10 := powerOf10 * 10 ].
	^ binaryNumber
]

{ #category : 'calculation' }
IntegerArithmetic >> recordStrOf: aNumber withBase: base [
	"Будує рядок - двійковий запис заданого числа"

	| givenNumber hexaArr k |
	givenNumber := aNumber.
	k := givenNumber numberOfDigitsInBase: base.
	hexaArr := Array new: k.
	[ givenNumber > 0 ] whileTrue: [
		hexaArr at: k put: (Character digitValue: givenNumber \\ base).
		givenNumber := givenNumber // base.
		k := k - 1 ].
	^ String withAll: hexaArr
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
				 font: StandardFonts codeFont;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
]
