const FormaterDate = (date) => {
    if (date) {
        return `${date.getDay()}/${date.getMonth() + 1}/${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`
    }
}

export {FormaterDate}
