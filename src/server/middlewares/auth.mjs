import jwt from 'jsonwebtoken'

const WHITE_ROUTES = ['/register', '/login_app', '/login_stats', '/login_bo']

const authToken = (req, res, next) => {
    // test la route authorisée sans token
    if (WHITE_ROUTES.some((r) => r === req.url)) {
        next()
        return
    }

    // test le header avec bearer
    const authHeader = req.headers['authorization']
    if (!authHeader) return res.sendStatus(401)

    // test l'existance du token
    const token = authHeader.split(' ')[1]
    if (token == null) return res.sendStatus(401)

    // test la validation du token
    jwt.verify(token, process.env.TOKEN, (err, data) => {
        if (err) {
            console.log('ERR : authToken', err)
            return res.sendStatus(403)
        }

        // utilisateur reconnu
        console.log(`User authenticated :  ${data.name}\n`)
        req.data = data
        next()
    })
}

export default authToken
