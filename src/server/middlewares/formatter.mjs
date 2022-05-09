/**
 * Formate une date au format Français : dd/MM/yyyy hh:mm:ss
 * @param date La date à formater
 * @returns {string}
 * @constructor
 */
const FormaterDate = (date) => {
    if (date) {
        return `${date.getMonth()}/${date.getDate() + 1}/${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`
    }
}

/**
 * Formate une date pour un nom de fichier : dd-MM-yyyy_hh-mm-ss
 * @param date La date à formater
 * @returns {string}
 * @constructor
 */
const ToStringForFilename = (date) => {
    if (date) {
        return `${date.getMonth()}-${date.getDate() + 1}-${date.getFullYear()}_${date.getHours()}-${date.getMinutes()}-${date.getSeconds()}-${date.getMilliseconds()}_`
    }
}

export {FormaterDate, ToStringForFilename}
