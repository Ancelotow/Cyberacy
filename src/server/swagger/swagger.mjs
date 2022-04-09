import swaggerAutogen from 'swagger-autogen'

const doc = {
    info: {
        version: "1.0.0",
        title: "Cyberacy API",
        description: "Documentation for Cyberacy API."
    },
    servers: [
        {
            url: "http://localhost:3000",
            description: "Local server",
        },
        {
            url: "https://cyberacy.herokuapp.com",
            description: "Online server",
        },
    ],
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
const endpointsFiles = ['./routes/manifestation.router.mjs', './routes/auth.router.mjs']
autogen(outputFile, endpointsFiles, doc)
