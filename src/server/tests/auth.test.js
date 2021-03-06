import {Person, Add} from '../models/person.mjs'
import {Authentication, Register} from "../controllers/auth.controller.mjs";

describe("Test resgiter", () => {
    let person = {
        nir: "541397454",
        lastname: "DUPOND",
        email: "jdupond@gmail.com",
        password: "test",
        birthday: '12-02-2001',
        address_street: 'rue des sycomores',
        town: '94079',
        sex: 1,
        profile: null
    }
    test("Nouvel ajout avec paramètres obligatoire manquant", () => Register({
        lastname: "DUPOND", email: "jdupond@gmail.com",
    }).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    test("Nouvel ajout sans données", () => Register(null).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    person.firstname = "Jean"
    test("Nouvel ajout normal", () => Register(person).then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
    test("Ajout d'un éxistant", () => Register(person).then((data) => expect(data).toMatchObject({
        status: 400, data: "This person already existed."
    })));
});

describe("Test login", () => {
    test("Connexion avec paramètres manquants", () => Authentication("541397454", null, "APP_IOS#CONNECTION").then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    test("Connexion avec identifiants invalides", () => Authentication("541397454", "tt", "APP_IOS#CONNECTION").then((data) => expect(data).toMatchObject({
        status: 401,
        data: "This NIR and password not matching."
    })));
    test("Connexion sur une ressources dont on a pas les droits", () => Authentication("541397454", "test", "APP_IOS#CONNECTION").then((data) => expect(data).toMatchObject({
        status: 401,
        data: "You are not allowed to access at this ressources."
    })));
    test("Connexion avec succès", () => Authentication("875543548", "test", "APP_IOS#CONNECTION").then((data) => expect(data).toMatchObject({
        status: 200
    })));
});
