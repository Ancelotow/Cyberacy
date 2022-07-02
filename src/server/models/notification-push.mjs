import axios from "axios";

class NotificationPush {
    to = "/topics/all"
    android_channel_id
    priority
    notification = new NotificationMessage()
}

class NotificationMessage {
    title
    body
}

const FCM_URI = "https://fcm.googleapis.com/fcm/send"
const FCM_HEADERS = {
    'Content-Type': 'application/json',
    'Authorization': `key=${process.env.FCM_TOKEN}`
}

NotificationPush.prototype.Send = function () {
    return new Promise((resolve, reject) => {
        axios.post(FCM_URI, this, {headers: FCM_HEADERS}).then((result) => {
            resolve(true)
        }).catch((error) => {
            reject(error)
        });
    });
}

NotificationPush.prototype.InitMessage = function(title, message) {
    let notificationMessage = new NotificationMessage()
    notificationMessage.body = message
    notificationMessage.title = title
    this.notification = notificationMessage
}

export {NotificationPush, NotificationMessage}