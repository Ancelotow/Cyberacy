import express from 'express'
import {routerAuth} from './routes/auth.router.mjs'
import bodyParser from 'body-parser'
import authToken from './middlewares/auth.mjs'
import swaggerUi from 'swagger-ui-express'
import {routerMan} from "./routes/manifestation.router.mjs";
import {routerRef} from "./routes/references.router.mjs";
import {routerGeo} from "./routes/geography.router.mjs";
import {config} from 'dotenv'
import morgan from 'morgan'
import file from 'fs'

const app = express()

config()
const port = process.env.PORT

// Body parser
app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())
app.use(bodyParser.json({type: 'application/*+json'}))

// Console
app.use(morgan('dev'))

// Swagger
const swagger = JSON.parse(file.readFileSync('./swagger/swagger_output.json', 'utf8'))
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swagger, { swaggerOptions: { persistAuthorization: true } }))

// Token JWT
app.use(authToken)

// Routers
app.use(routerAuth)
app.use(routerMan)
app.use(routerGeo)
app.use(routerRef)

app.listen(port, () => {
    console.log(`Server listen on port ${port}`)
});
