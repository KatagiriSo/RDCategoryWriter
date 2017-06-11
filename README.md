# RDCategoryWriteraa
It is a program to transform Diagram used in Categorical Theory to LaTex (xymatrix) using Swift.

```swift
let maxsize = (4,4)
var matrix:[String:(Int,Int)] = [:]
aaaaa
// element
["A","B","C","D"].enumerated().forEach {
  matrix[$0.1] = ($0.0,0)
}

// arrows
let abcds = [["A","B","f"],["B","C","g"],["C","D","h"]]
let abcdArrows = abcds.map { Arrow($0) }

// E
matrix["E"] = (3,3)
let others = ["A","B","C","D"].enumerated().map {
   Arrow([$0.1,"E","z" + "\($0.0)"])
}

let arrows = abcdArrows + others

display(matrix:matrix, matrixsize:maxsize, arrows:arrows)

```

