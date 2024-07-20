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

{ #category : 'input' }
NestedLoops >> inputNatural [
	"Відкриває вікно діалогу для введення цілого числа. Не виконує ніяких перевірок"

	^ (UIManager default
		   request: 'Введіть натуральне число - розмір матриці'
		   initialAnswer: '2'
		   title: 'Запит') asInteger abs
]
