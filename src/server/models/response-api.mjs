class ResponseApi {
    status = "OK"
    message = null
    data = null
}

ResponseApi.prototype.InitError = function(ex) {
    this.status = "KO"
    this.message = ex.message
    this.data = ex
}

export {ResponseApi}