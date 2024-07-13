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
