import {Person, Add} from '../models/person.mjs'
import {Register} from "../controllers/auth.controller.mjs";

describe("Test ajout personne", () => {
    let person = {
        nir: "541397454",
        lastname: "DUPOND",
        email: "jdupond@gmail.com",
        password: "test",
        birthday: '12-02-2001',
        address_street: 'rue des sycomores',
        town: '94130',
        sex: 1,
        profile: null
    }
    test("Nouvel ajout avec paramètres obligatoire manquant", () => Register({
        lastname: "DUPOND",
        email: "jdupond@gmail.com",
    }).then((data) => expect(data).toMatchObject({
        status: 400,
        data: "Missing parameters."
    })));
    test("Nouvel ajout sans données", () => Register(null).then((data) => expect(data).toMatchObject({
        status: 400,
        data: "Missing parameters."
    })));
    person.firstname = "Jean"
    test("Nouvel ajout normal", () => Register(person).then((data) => expect(data).toMatchObject({
        status: 201,
        data: "Person has been created."
    })));
    test("Ajout d'un éxistant", () => Register(person).then((data) => expect(data).toMatchObject({
        status: 400,
        data: "This person already existed."
    })));
});
