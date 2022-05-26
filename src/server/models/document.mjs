import {pool} from "../middlewares/postgres.mjs";

class Document {
    id
    originalname
    path
    mimetype
    filename
    size
}

const Add = (document) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'INSERT INTO document(doc_original_name, doc_filename, doc_path, doc_mime_type, doc_size) VALUES ($1, $2, $3, $4, $5) RETURNING doc_id',
            values: [document.originalname, document.filename, document.path, document.mimetype, document.size],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res.doc_id)
            }
        });
    });
}

export default {Document, Add}

