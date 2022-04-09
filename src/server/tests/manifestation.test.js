import manifestation from "../controllers/manifestation.controller.mjs";

describe("Test récupération des manifestations", () => {
    test("Récupération des manifestations non annulées", () => manifestation.GetAllManifestations(false, null).then((data) => expect(data).toMatchObject({
        status: 200
    })));
    test("Récupération de toutes les manifestation", () => manifestation.GetAllManifestations(true, null).then((data) => expect(data).toMatchObject({
        status: 200
    })));
    test("Récupération de toutes les manifestation auxquelles je participe", () => manifestation.GetAllManifestations(true, '541397454').then((data) => expect(data).toMatchObject({
        status: 200
    })));
});

describe("Test ajout d'une manifestations", () => {
    test("Ajout avec aucune manifestation", () => manifestation.AddManifestation(null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout d'une manifestation avec des paramètres manquant", () => manifestation.AddManifestation({
        name: "test",
        nb_person_estimate: 0
    }).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout d'une manifestation", () => manifestation.AddManifestation({
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
    test("Annulation d'une manifestation avec des paramètres manquant", () => manifestation.AbortedManifestation(null, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Annulation d'une manifestation n'existant pas", () => manifestation.AbortedManifestation(1000, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Annulation d'une manifestation", () => manifestation.AbortedManifestation(1, "Plus envi").then((data) => expect(data).toMatchObject({
        status: 200
    })));
})

describe("Test participation à une manifestations", () => {
    test("Participation à une manifestation avec des paramètres manquant", () => manifestation.Participate(null, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Participation à une manifestation n'existant pas", () => manifestation.Participate('1000', 54).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    /*test("Participation à une manifestation", () => manifestation.Participate('541397454', 2).then((data) => expect(data).toMatchObject({
        status: 200
    })));*/
})
