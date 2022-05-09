import multer from "multer"
import path from "path"
import {ToStringForFilename} from "./formatter.mjs";

const createUpload = () => {
    const __dirname = path.resolve()
    const storage = multer.diskStorage({
        destination: function (request, file, callback) {
            callback(null, './uploads/');
        },
        filename: function (request, file, callback) {
            const today = new Date()
            const filename = `${ToStringForFilename(today)}${file.originalname}`
            callback(null, filename)
        }
    });
    return multer({ storage: storage, limits: {fileSize: 1000000}});
}

export {createUpload}
