const FormaterDate = (date) => {
    if (date) {
        return `${date.getMonth()}/${date.getDate() + 1}/${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`
    }
}

export {FormaterDate}
