import swaggerAutogen from 'swagger-autogen'
import models from './models.mjs'

const doc = {
    info: {
        version: "1.0.0", title: "Cyberacy API", description: "Documentation for Cyberacy API."
    },
    host: "cyberacy.herokuapp.com",
    basePath: "/",
    schemes: ['https'],
    produces: ['application/json'],
    definitions: {
        ...models
    },
    securityDefinitions: {
        Bearer: {
            type: "apiKey",
            in: "header",
            name: "Authorization",
            description: "Rentrez un token valide dans le format **Bearer &lt;token>**",
        },
    }
}

const autogen = swaggerAutogen()
const outputFile = './swagger/swagger_output.json'
const endpointsFiles = [
    './routes/manifestation.router.mjs',
    './routes/auth.router.mjs',
    './routes/references.router.mjs',
    './routes/geography.router.mjs',
    './routes/vote.router.mjs',
    './routes/party.router.mjs',
    './routes/meeting.router.mjs',
    './routes/messaging.router.mjs',
    './routes/stats.router.mjs',
    './routes/payment.router.mjs',
    './routes/notification-push.router.mjs'
]

autogen(outputFile, endpointsFiles, doc)
