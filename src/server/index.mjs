import express from 'express'
import {routerAuth} from './routes/auth.router.mjs'
import bodyParser from 'body-parser'
import swaggerUI from 'swagger-ui-express'
import {config} from 'dotenv'
import morgan from 'morgan'

const app = express()

config()
const port = process.env.PORT

// Body parser
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(bodyParser.json({ type: 'application/*+json' }))

// Routers
app.use(routerAuth)

// Console
app.use(morgan('dev'))

app.listen(port, () => {
    console.log(`Server listen on port ${port}`)
});
