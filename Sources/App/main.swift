import Hummingbird

let app = Application()

try createTable()

// HOME
app.get("/") { req async throws -> Response in
    let projects = try getProjects()
    return Response(html: renderHome(projects))
}

// CREATE
app.post("/add") { req async throws -> Response in
    let p = try req.decode(as: Project.self)
    try addProject(p)
    return Response.redirect(to: "/")
}

// UPDATE
app.post("/update/:id") { req async throws -> Response in
    let id = req.parameters.get("id", as: Int.self)!
    var p = try req.decode(as: Project.self)
    p.id = id

    try updateProject(p)
    return Response.redirect(to: "/")
}

// DELETE
app.post("/delete/:id") { req async throws -> Response in
    let id = req.parameters.get("id", as: Int.self)!
    try deleteProject(id)
    return Response.redirect(to: "/")
}

// DONATE
app.post("/donate/:id") { req async throws -> Response in
    let id = req.parameters.get("id", as: Int.self)!
    let amount = try req.query.get("amount", as: Double.self)

    try donate(id, amount: amount)
    return Response.redirect(to: "/")
}

app.get("/project/:id") { req async throws -> Response in
    let id = req.parameters.get("id", as: Int.self)!
    let project = try getProjectById(id)

    return Response(html: renderDetail(project!))
}

try app.start()