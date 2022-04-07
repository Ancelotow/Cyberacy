import express from 'express'
import {routerAuth} from './routes/auth.router.mjs'
import bodyParser from 'body-parser'
import swaggerUI from 'swagger-ui-express'
import authToken from './middlewares/auth.mjs'
import {routerMan} from "./routes/manifestation.router.mjs";
import {config} from 'dotenv'
import morgan from 'morgan'

const app = express()

config()
const port = process.env.PORT

// Body parser
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(bodyParser.json({ type: 'application/*+json' }))

// Console
app.use(morgan('dev'))

// Token JWT
app.use(authToken)

// Routers
app.use(routerAuth)
app.use(routerMan)

app.listen(port, () => {
    console.log(`Server listen on port ${port}`)
});
