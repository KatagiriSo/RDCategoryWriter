//
//  rdcategorywriter.swift
//  rdcategorywriter
//
//  Created by KatagiriSo on 2017/6/12.
//  Copyright © 2017年 RodhosSoft. All rights reserved.
//


struct Arrow {
  let first:String
  let last:String
  let comment:String

  init(_ list:[String]) {
    first = list[0]
    last = list[1]
    comment = list[2]
  }
}

func search(_ matrix:[String:(Int,Int)], _ x:Int, _ y:Int) -> String {
  let (key, _) = matrix.first { (key,value) in
    return value.0 == x && value.1 == y
  } ?? ("",(0,0))

  return key
}

func dup(str:String, n:Int) -> String{
  if n == 0 {
    return ""
  } else {
    return str + dup(str:str, n:n-1)
  }
}

func ar(arrow:Arrow, matrix:[String:(Int,Int)]) -> String {
  let first = matrix[arrow.first]!
  let last = matrix[arrow.last]!
  let dx = last.0 - first.0
  let dy = last.1 - first.1

  let hor = {() -> String in
    if dx > 0 {
        return dup(str:"r", n:dx)
      } else if dx < 0 {
        return dup(str:"l", n:-1*dx)
      }
      return ""
  }()

  let ver = {() -> String in
    if dy > 0 {
        return dup(str:"d", n:dy)
      } else if dy < 0 {
        return dup(str:"u", n:-1*dy)
      }
      return ""
  }()

  let tot = "\\ar[" + hor + ver + "]^" + "{" + arrow.comment + "}"

  return tot
}


func display(matrix:[String:(Int,Int)],matrixsize:(Int,Int),arrows:[Arrow]) {
print("\\xymatrix{")

for a in 0..<(maxsize.0) {
  var list:[String] = []
  //print("\(a)")
  for b in 0..<(maxsize.1) {
  //print("\(b)")
    let key = search(matrix,b,a)
    //print("\(key)")
    let ars = arrows.filter {$0.first == key}
    let result = ars.map {
      ar(arrow:$0, matrix:matrix)
    }.joined(separator:" ")

    let last = maxsize.1 - 1
    let _and_ = b != last ? " & " : ""
    list.append("\(key) \(result) \(_and_)")
  }

  let last = maxsize.0 - 1
  let _bs_ = a != last ? " \\\\" : ""
  list.append("\(_bs_)")
  print("\(list.joined(separator:""))")
}
print("}")
}


// --------------------------------------
let maxsize = (4,4)
var matrix:[String:(Int,Int)] = [:]

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
