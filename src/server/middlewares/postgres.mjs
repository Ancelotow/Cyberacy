import pg from 'pg'

const pool = new pg.Pool({
    user: "postgres",
    host: "localhost",
    database: "cyberacy",
    password: "azerty",
    port: "5432"
});

export {pool}
