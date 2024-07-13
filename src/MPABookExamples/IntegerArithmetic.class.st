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
