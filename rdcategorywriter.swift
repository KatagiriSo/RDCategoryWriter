//
//  rdcategorywriter.swift
//  rdcategorywriter
//
//  Created by KatagiriSo on 2017/6/12.
//  Copyright © 2017年 RodhosSoft. All rights reserved.
//

typealias Vec = (x:Int,y:Int)

let debugMode = true

func debugLog(_ str:String) {
    if debugMode {
        print(str)
    }
}

struct Category {
    var objects:[CObject]
    func arrows()->[CArrow] {
        return objects.flatMap {$0.arrows}
    }
    func matrixSize()->Vec {
        var x = 0
        var y = 0
        self.objects.forEach {
            if (x < $0.location.x) {
                x = $0.location.x
            }
            if (y < $0.location.y) {
                y = $0.location.y
            }
        }
//        debugLog("max size\((x+1,y+1))")
        return (x:x+1,y:y+1)
    }
}

class CObject {
    static var currentid = 0
    var location:Vec = (x:0,y:0)
    var name:String
    var id:String
    var tempRelation:CObject? = nil
    var arrows:[CArrow] = []
    init(_ name:String) {
        self.name = name
        self.id = String(CObject.currentid)
        CObject.currentid = CObject.currentid + 1
    }
    
    func addRight(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x+1+dx, y:self.location.y+dy)
        self.tempRelation = o
        return self
    }
    
    func addDown(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x+dx, y:self.location.y+1+dy)
        self.tempRelation = o
        return self
    }
    
    func addUp(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x+dx, y:self.location.y-1+dy)
        self.tempRelation = o
        return self
    }
    
    func addLeft(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x-1+dx, y:self.location.y+dy)
        self.tempRelation = o
        return self
    }
    
    func addUpRight(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x+1+dx, y:self.location.y-1+dy)
        self.tempRelation = o
        return self
    }
    
    func addDownRight(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x+1+dx, y:self.location.y+1+dy)
        self.tempRelation = o
        return self
    }
    
    func addDownLeft(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x-1+dx, y:self.location.y+1+dy)
        self.tempRelation = o
        return self
    }
    
    func addUpLeft(_ o:CObject, dx:Int=0,dy:Int=0) -> CObject {
        o.location = (x:self.location.x-1+dx, y:self.location.y-1+dy)
        self.tempRelation = o
        return self
    }
    
    func setArrow(_ name:String, isUpper:Bool = true, attr:String = "") -> CObject {
        if let t = self.tempRelation {
            let up = (isUpper==true) ? name : ""
            let down = (isUpper==true) ? "" : name
            let a = CArrow(dom:self, cod:t, up:up, down:down, attr:attr)
            self.arrows.append(a)
            return t
        }
        let up = (isUpper==true) ? name : ""
        let down = (isUpper==true) ? "" : name
        let a = CArrow(dom:self, cod:self, up:up, down:down, attr:attr)
        self.arrows.append(a)
        return self
    }
    
    func to(_ ob:CObject) -> CObject {
        self.tempRelation = ob
        return self
    }
}

class CArrow {
    init(dom:CObject, cod:CObject, up:String="", down:String="", attr:String = "") {
        self.dom = dom
        self.cod = cod
        self.upperComment = up
        self.underComment = down
        self.attr = attr
    }
    var type:String = ""
    var upperComment:String
    var underComment:String
    var dom:CObject
    var cod:CObject
    var attr:String
}



func matrix(_ category:Category) -> (matrix:[String:(Int,Int)], maxsize:Vec, arrows:[Arrow]){
    
    let maxsize = category.matrixSize()
    var matrix:[String:(Int,Int)] = [:]
    category.objects.forEach {
        matrix[$0.name] = ($0.location.x, $0.location.y)
    }
    
    let ars = category.arrows().map {
        [$0.dom.name, $0.cod.name, $0.upperComment, $0.underComment, $0.attr]
        }.map {Arrow($0)}
    return (matrix:matrix, maxsize:maxsize, arrows:ars)
}


struct Arrow {
    let first:String
    let last:String
    let d_comment:String
    let u_comment:String
    let attr:String
    
    init(_ list:[String]) {
        first = list[0]
        last = list[1]
        d_comment = list[2]
        u_comment = list[3]
        attr = list[4]
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

    
    let tot = "\\ar\(arrow.attr)[" + hor + ver + "]"
        + "_" + "{" + arrow.d_comment + "}"
        + "^" + "{" + arrow.u_comment + "}"
    
    return tot
}


func display(matrix:[String:(Int,Int)],matrixsize:(Int,Int),arrows:[Arrow]) {
    print("\\xymatrix{")
    
    for a in 0..<(matrixsize.1) {
        var list:[String] = []
//        debugLog("a=\(a)")
        for b in 0..<(matrixsize.0) {
//            debugLog("b=\(b)")
            let key = search(matrix,b,a)
//            debugLog("\(key)")
            let ars = arrows.filter {$0.first == key}
            let result = ars.map {
                ar(arrow:$0, matrix:matrix)
                }.joined(separator:" ")
            
            let last = matrixsize.0 - 1
            let _and_ = b != last ? " & " : ""
            list.append("\(key) \(result) \(_and_)")
        }
        
        let last = matrixsize.1 - 1
        let _bs_ = a != last ? " \\\\" : ""
        list.append("\(_bs_)")
        print("\(list.joined(separator:""))")
    }
    print("}")
}


// --------------------------------------

func templetaeBegin() {
    print(
        """
\\documentclass[11pt,a4paper]{jsarticle}
\\usepackage[all,cmtip]{xy}
        
\\begin{document}
""")
}

func templetaeEnd() {
    print("\\end{document}")
}


/// Sample 1
//func commutative() {
//
//    // object
//    let maxsize = (2,2)
//    var matrix:[String:(Int,Int)] = [:]
//    matrix["A"] = (0,0)
//    matrix["B"] = (0,1)
//    matrix["C"] = (1,0)
//    matrix["D"] = (1,1)
//
//    // arrows
//    let abcds = [["A","B","f",""],
//                 ["B","D","g",""],
//                 ["A","C","h",""],
//                 ["C","D","i",""]]
//    let abcdArrows = abcds.map { Arrow($0) }
//
//    display(matrix:matrix, matrixsize:maxsize, arrows:abcdArrows)
//}
//
//
///// Sample2
//
//func sample1() {
//
//    let maxsize = (4,4)
//    var matrix:[String:(Int,Int)] = [:]
//
//    // element
//    ["A","B","C","D"].enumerated().forEach {
//        matrix[$0.1] = ($0.0,0)
//    }
//
//    // arrows
//    let abcds = [["A","B","","f"],["B","C","g",""],["C","D","h",""]]
//    let abcdArrows = abcds.map { Arrow($0) }
//
//    // E
//    matrix["E"] = (3,3)
//    let others = ["A","B","C","D"].enumerated().map {
//        Arrow([$0.1,"E","z" + "\($0.0)",""])
//    }
//
//    let arrows = abcdArrows + others
//
//    display(matrix:matrix, matrixsize:maxsize, arrows:arrows)
//}
//
//
//////

func sample() {
    let z = CObject("Z")

    let a = CObject("A")
    let b = CObject("B")
    let c = CObject("C")
    let d = CObject("D")
    
    z.addDownRight(a,dx:1)

    a.addRight(b).setArrow("f").addDown(d).setArrow("g")
    a.addDown(c).setArrow("h").addRight(d).setArrow("k")
    
    z.to(a).setArrow("l1")
    z.to(b).setArrow("l2",attr:"@(ur,dr)")
    z.to(c).setArrow("l3")
    z.to(d).setArrow("l4")
    
    let cat = Category(objects:[z,a,b,c,d])
    let mat = matrix(cat)
    display(matrix:mat.matrix, matrixsize:mat.maxsize, arrows:mat.arrows)
}

templetaeBegin()
sample()
templetaeEnd()




