# RDCategoryWriter
It is a program to transform Diagram used in Categorical Theory to LaTex (xymatrix) using Swift.

```swift
func sample() {
    let a = CObject("a")
    let b = CObject("b")
    let c = CObject("c")
    let d = CObject("d")

    a.addRight(b).setArrow("f").addDown(d).setArrow("g")
    a.addDown(c).setArrow("h").addRight(d).setArrow("k")
    
    let cat = Category(objects:[a,b,c,d])
    let mat = matrix(cat)
    display(matrix:mat.matrix, matrixsize:mat.maxsize, arrows:mat.arrows)
}


```

# Output
```latex
\xymatrix{
a \ar[r]_{f}^{} \ar[d]_{h}^{}  & b \ar[d]_{g}^{}  \\
c \ar[r]_{k}^{}  & d
}
```