import manifestation from "../controllers/manifestation.controller.mjs";

describe("Test récupération des manifestations", () => {
    test("Récupération des manifestations non annulées", () => manifestation.GetAllManifestations(false, null).then((data) => expect(data).toMatchObject({
        status: 200
    })));
    test("Récupération de toutes les manifestation", () => manifestation.GetAllManifestations(true, null).then((data) => expect(data).toMatchObject({
        status: 200
    })));
    test("Récupération de toutes les manifestation auxquelles je participe", () => manifestation.GetAllManifestations(true, '875543548').then((data) => expect(data).toMatchObject({
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
    test("Annulation d'une manifestation", () => manifestation.AbortedManifestation(3, "Plus envi").then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
})

describe("Test participation à une manifestations", () => {
    test("Participation à une manifestation avec des paramètres manquant", () => manifestation.Participate(null, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    /*test("Participation à une manifestation", () => manifestation.Participate('875543548', 3).then((data) => expect(data).toMatchObject({
        status: 201
    })));*/
})

describe("Test gestion des options d'une manifestations", () => {
    test("Ajout d'une option à une manifestation avec des paramètres manquant", () => manifestation.AddOption(null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout d'une option à une manifestation", () => manifestation.AddOption({
        name: "Test",
        id_manifestation: 3
    }).then((data) => expect(data).toMatchObject({
        status: 201
    })));
    test("Récupération des options d'une manifestations", () => manifestation.GetOptions(3).then((data) => expect(data).toMatchObject({
        status: 200
    })));
})

describe("Test gestion des étapes d'une manifestations", () => {
    test("Ajout d'une étape à une manifestation avec des paramètres manquant", () => manifestation.AddStep(null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout d'une étape à une manifestation", () => manifestation.AddStep({
        address_street: "28 rue de Noisy",
        date_arrived: "2022-05-20",
        id_manifestation: 3,
        id_step_type: 1,
        town_code_insee: "94079"
    }).then((data) => expect(data).toMatchObject({
        status: 201
    })));
    test("Récupération des étapes d'une manifestations", () => manifestation.GetSteps(3).then((data) => expect(data).toMatchObject({
        status: 200
    })));
})
