import swaggerAutogen from 'swagger-autogen'

const doc = {
    info: {
        version: "1.0.0", title: "Cyberacy API", description: "Documentation for Cyberacy API."
    },
    host: "localhost:3000",
    basePath: "/",
    schemes: ['http', 'https'],
    consumes: ['application/json'],
    produces: ['application/json'],
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
const endpointsFiles = ['./routes/manifestation.router.mjs', './routes/auth.router.mjs', './routes/references.router.mjs', './routes/geography.router.mjs']
autogen(outputFile, endpointsFiles, doc)