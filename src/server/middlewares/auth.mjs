import jwt from 'jsonwebtoken'

const WHITE_ROUTES = ['/register', '/login_app', '/login_stats', '/login_bo']

const authToken = (req, res, next) => {
    // Vérifie sila route est sans token ou pas
    if (WHITE_ROUTES.some((r) => r === req.url)) {
        next()
        return
    }

    // Vérifie la présence du header "Authorization"
    const authHeader = req.headers['authorization']
    if (!authHeader) return res.sendStatus(401)

    // Vérifie la présence du token
    const token = authHeader.split(' ')[1]
    if (token == null) return res.sendStatus(401)

    // Test la validité du token
    jwt.verify(token, process.env.TOKEN, (err, data) => {
        // Le token est mauvais
        if (err) {
            return res.sendStatus(403)
        }
        // utilisateur reconnu
        req.data = data
        next()
    })
}

export default authToken
