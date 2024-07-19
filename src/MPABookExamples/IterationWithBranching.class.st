"
Реалізація алгоритмів розділу 3. Поєднання повторення з галуженням
"
Class {
	#name : 'IterationWithBranching',
	#superclass : 'Object',
	#category : 'MPABookExamples-Chapter03',
	#package : 'MPABookExamples',
	#tag : 'Chapter03'
}

{ #category : 'output' }
IterationWithBranching >> informAbout: aString [
	"Повідомляє результат у інформаційному вікні, що закривається автоматично"

	UIManager default message: aString title: 'Результати обчислень'
]

{ #category : 'input' }
IterationWithBranching >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число'
		   initialAnswer: '1'
		   title: 'Запит') asInteger abs
]

{ #category : 'input' }
IterationWithBranching >> inputNthNumber: n [
	"Відкриває вікно діалогу для введення дійсного числа, n-го члена послідовності.
	 Не виконує ніяких перевірок"

	^ Float readFrom: (UIManager default
		   textEntry: 'Введіть ', n printString, '-e число'
		   title: 'Запит') readStream
]

{ #category : 'input' }
IterationWithBranching >> inputSequenceOf: count [
	"Відкриває вікно діалогу для введення послідовності count чисел. Повертає рядок.
	 Не виконує ніяких перевірок"

	^ UIManager default
		   textEntry: 'Введіть послідовність', count printString, ' чисел, відокремлених пропуском'
		   title: 'Запит'
]

{ #category : 'output' }
IterationWithBranching >> showWindowLabeled: labelString with: text [
	"Відкриває окреме текстове вікно з об'ємними результатами"

	(SystemWindow labelled: labelString)
		addMorph: (RubScrolledTextMorph new
				 setText: text;
				 font: StandardFonts codeFont;
				 yourself)
		frame: (0 @ 0 corner: 1 @ 1);
		openInWorld
]
