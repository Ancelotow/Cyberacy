import {
    GetAllManifestations,
    AddManifestation,
    AbortedManifestation
} from "../controllers/manifestation.controller.mjs";

describe("Test récupération des manifestations", () => {
    test("Récupération des manifestations non annulées", () => GetAllManifestations(false).then((data) => expect(data).toMatchObject({
        status: 200
    })));
    test("Récupération de toutes les manifestation", () => GetAllManifestations(true).then((data) => expect(data).toMatchObject({
        status: 200
    })));
});

describe("Test ajout d'une manifestations", () => {
    test("Ajout avec aucune manifestation", () => AddManifestation(null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout d'une manifestation avec des paramètres manquant", () => AddManifestation({
        name: "test",
        nb_person_estimate: 0
    }).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout d'une manifestation", () => AddManifestation({
        name: "Gilets Jaunes",
        object: "Pas content",
        nb_person_estimate: 0,
        date_start: new Date(),
        date_end: new Date()
    }).then((data) => expect(data).toMatchObject({
        status: 201
    })));
})

describe("Test annulation d'une manifestations", () => {
    test("Annulation d'une manifestation avec des paramètres manquant", () => AbortedManifestation(null, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Annulation d'une manifestation n'existant pas", () => AbortedManifestation(1000, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Annulation d'une manifestation", () => AbortedManifestation(1, "Plus envi").then((data) => expect(data).toMatchObject({
        status: 200
    })));
})
