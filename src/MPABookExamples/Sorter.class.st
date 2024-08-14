"
Містить масив, уміє впорядковувати його елементи швидким сортуванням
"
Class {
	#name : 'Sorter',
	#superclass : 'Object',
	#instVars : [
		'arr'
	],
	#category : 'MPABookExamples-Chapter10',
	#package : 'MPABookExamples',
	#tag : 'Chapter10'
}

{ #category : 'examples' }
Sorter class >> example1 [

	^ self new arr:
		  (#( #( 5 $a ) #( 3 $a ) #( 9 $a ) #( 2 $a ) #( 1 $a ) #( 2 $b )
		      #( 6 $a ) #( 5 $b ) #( 8 $a ) #( 3 $b ) #( 4 $a ) #( 7 $a )
		      #( 2 $c ) #( 8 $b ) #( 5 $c ) #( 5 $d ) ) collect: [ :arr |
			   ExtInt newFrom: arr ])
]

{ #category : 'accessing' }
Sorter >> arr [

	^ arr
]

{ #category : 'accessing' }
Sorter >> arr: anArray [

	arr := anArray copy
]

{ #category : 'printing' }
Sorter >> printOn: stream [

	arr do: [ :each |
		stream
			nextPutAll: '  ';
			print: each ].
	stream cr
]

{ #category : 'sorting' }
Sorter >> quickSort [

	self quickSortFrom: 1 to: arr size
]

{ #category : 'private' }
Sorter >> quickSortFrom: low to: high [

	| endOfSmall beginOfLarge pivot |
	endOfSmall := high.
	beginOfLarge := low.
	pivot := arr at: low + high // 2.
	[ beginOfLarge <= endOfSmall ] whileTrue: [ 
		[ pivot > (arr at: beginOfLarge) ] whileTrue: [ beginOfLarge := beginOfLarge + 1 ].
		[ (arr at: endOfSmall) > pivot ] whileTrue: [ endOfSmall := endOfSmall - 1 ].
		beginOfLarge < endOfSmall
			ifTrue: [ | toSwap | toSwap := arr at: beginOfLarge.
				arr at: beginOfLarge put: (arr at: endOfSmall).
				arr at: endOfSmall put: toSwap.
				beginOfLarge := beginOfLarge + 1.
				endOfSmall := endOfSmall - 1 ]
			ifFalse: [ 
				beginOfLarge = endOfSmall ifTrue: [ 
					beginOfLarge := beginOfLarge + 1.
					endOfSmall := endOfSmall - 1 ] ] ].
	endOfSmall > low ifTrue: [ self quickSortFrom: low to: endOfSmall ].
	beginOfLarge < high ifTrue: [ self quickSortFrom: beginOfLarge to: high ]
]

{ #category : 'sorting' }
Sorter >> stableQuickSort [

	self stableSortFrom: 1 to: arr size
]

{ #category : 'private' }
Sorter >> stableSortFrom: start to: end [

	| pivotIndex beginOfUnsorted |
	pivotIndex := start.
	beginOfUnsorted := start + 1.
	[ beginOfUnsorted <= end ] whileTrue: [ 
		(arr at: pivotIndex) > (arr at: beginOfUnsorted) ifTrue: [ 
			| toTransfer | toTransfer := arr at: beginOfUnsorted.
			beginOfUnsorted - 1 to: pivotIndex by: -1 do: [ :k |
				arr at: k + 1 put: (arr at: k) ].
			arr at: pivotIndex put: toTransfer.
			pivotIndex := pivotIndex + 1 ].
		beginOfUnsorted := beginOfUnsorted + 1 ].
	pivotIndex > 2 ifTrue: [ self stableSortFrom: 1 to: pivotIndex - 1 ].
	end - pivotIndex > 1 ifTrue: [ self stableSortFrom: pivotIndex + 1 to: end ]
]
