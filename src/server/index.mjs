import express from 'express'
import {routerAuth} from './routes/auth.router.mjs'
import bodyParser from 'body-parser'
import authToken from './middlewares/auth.mjs'
import swaggerUi from 'swagger-ui-express'
import {routerMan} from "./routes/manifestation.router.mjs";
import {routerRef} from "./routes/references.router.mjs";
import {routerGeo} from "./routes/geography.router.mjs";
import {routerVote} from "./routes/vote.router.mjs";
import {routerParty} from "./routes/party.router.mjs";
import {routerMee} from "./routes/meeting.router.mjs";
import {routerMsg} from "./routes/messaging.router.mjs";
import {routerStats} from "./routes/stats.router.mjs";
import jobGeography from "./cron/geography.cron.mjs"
import cors from 'cors'
import {config} from 'dotenv'
import morgan from 'morgan'
import file from 'fs'
import aws from 'aws-sdk';

const app = express()

config()
const port = process.env.PORT

// Body parser
app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.json())
app.use(bodyParser.json({type: 'application/*+json'}))

// Console
app.use(morgan('dev'))

// CORS
app.use(cors());

// Swagger
const swagger = JSON.parse(file.readFileSync('./swagger/swagger_output.json', 'utf8'))
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swagger, {swaggerOptions: {persistAuthorization: true}}))

// Token JWT
app.use(authToken)

// AWS S3 (Pour les uploads)
aws.config.region = 'eu-west-1';

// Routers
app.use(routerAuth)
app.use(routerMan)
app.use(routerGeo)
app.use(routerRef)
app.use(routerVote)
app.use(routerParty)
app.use(routerMee)
app.use(routerMsg)
app.use(routerStats)

// Cron jobs
jobGeography.startJob()


app.listen(port, () => {
    console.log(`Server listen on port ${port}`)
});
