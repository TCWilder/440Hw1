//Modified by Thomas Clark on 10/25/20

import Kitura
import Cocoa

let router = Router()

router.all("/PersonService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}

router.get("PersonService/getAll"){
    request, response, next in
    let pList = PersonDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(pList)
    //JSONArray 
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    // response.send("getAll service response data : \(pList.description)")
    next()
}

router.post("PersonService/add") {
    request, response, next in
    // JSON deserialization on Kitura server 
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let fn = jDict["firstName"],let ln = jDict["lastName"],let n = jDict["ssn"] {
            let pObj = Person(fn:fn, ln:ln, n:n)
            PersonDao().addPerson(pObj: pObj)
        }
    }
    response.send("The Person record was successfully inserted (via POST Method).")
    next()
}
router.get("/PersonService/add") {
    request, response, next in
    let fn = request.queryParameters["FirstName"]
    let ln = request.queryParameters["LastName"]
    //
    // let n = ....
    // if n != nil {
    // ... }
    if let n = request.queryParameters["SSN"] {
        let pObj = Person(fn:fn, ln:ln, n:n)
        PersonDao().addPerson(pObj: pObj)
        response.send("The Person record was successfully inserted.")
    } else {
        
    }
    next() 
}

router.all("/ClaimService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the claim service. ")
    next()
}

router.get("ClaimService/getAll"){
    request, response, next in
    let cList = ClaimDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(cList)
    //JSONArray
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}

router.post("ClaimService/add") {
    request, response, next in
    // JSON deserialization on Kitura server
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let iid = jDict["id"],let ititle = jDict["title"],let idate = jDict["date"], let isolved = jDict["isSolved"]{
            let cObj = Claim(iid: iid, ititle: ititle, idate: idate, isolved: Bool(isolved))
            ClaimDao().addClaim(cObj: cObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}
router.get("/ClaimService/add") {
    request, response, next in
    let isolved = request.queryParameters["isSolved"]
    let ititle = request.queryParameters["title"]
    let idate = request.queryParameters["date"]
    if let iid = request.queryParameters["id"] {
        let cObj = Claim(iid:iid, ititle: ititle, idate: idate, isolved: Bool(isolved!))
        ClaimDao().addClaim(cObj: cObj)
        response.send("The Claim record was successfully inserted.")
    } else {
        
    }
    next()
}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

