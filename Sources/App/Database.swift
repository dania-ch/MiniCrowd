import Foundation
import SQLite

let db = try Connection("db.sqlite3")

let projects = Table("projects")

let id = Expression<Int>("id")
let title = Expression<String>("title")
let description = Expression<String>("description")
let goal = Expression<Double>("goal")
let currentAmount = Expression<Double>("currentAmount")

// MARK: - CREATE TABLE
func createTable() throws {
    try db.run(projects.create(ifNotExists: true) { t in
        t.column(id, primaryKey: .autoincrement)
        t.column(title)
        t.column(description)
        t.column(goal)
        t.column(currentAmount)
    })
}

// MARK: - CREATE
func addProject(_ p: Project) throws {
    let insert = projects.insert(
        title <- p.title,
        description <- p.description,
        goal <- p.goal,
        currentAmount <- p.currentAmount
    )
    try db.run(insert)
}

// MARK: - READ
func getProjects() throws -> [Project] {
    var list: [Project] = []

    for p in try db.prepare(projects) {
        list.append(Project(
            id: p[id],
            title: p[title],
            description: p[description],
            goal: p[goal],
            currentAmount: p[currentAmount]
        ))
    }

    return list
}

// MARK: - UPDATE
func updateProject(_ p: Project) throws {
    guard let pid = p.id else { return }

    let project = projects.filter(id == pid)

    try db.run(project.update(
        title <- p.title,
        description <- p.description,
        goal <- p.goal,
        currentAmount <- p.currentAmount
    ))
}

// MARK: - DELETE
func deleteProject(_ pid: Int) throws {
    let project = projects.filter(id == pid)
    try db.run(project.delete())
}

// MARK: - DONATE (BONUS)
func donate(_ pid: Int, amount: Double) throws {
    let project = projects.filter(id == pid)

    if let p = try db.pluck(project) {
        let newAmount = p[currentAmount] + amount
        try db.run(project.update(currentAmount <- newAmount))
    }
}

// MARK: - GET BY ID (BONUS)
func getProjectById(_ pid: Int) throws -> Project? {
    let project = projects.filter(id == pid)

    if let p = try db.pluck(project) {
        return Project(
            id: p[id],
            title: p[title],
            description: p[description],
            goal: p[goal],
            currentAmount: p[currentAmount]
        )
    }
    return nil
}