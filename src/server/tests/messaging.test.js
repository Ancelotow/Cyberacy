import messaging from "../controllers/messaging.controller.mjs";

describe("Test création d'un Thread", () => {
    test("Création d'un thread avec aucun manquant", () => messaging.AddThread(null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Création d'un thread avec paramètres manquant", () => messaging.AddThread({id_political_party: 2}).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Création d'un thread", () => messaging.AddThread({
        name: "LREM Thread", id_political_party: 3
    }).then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

describe("Test modification d'un Thread", () => {
    test("Modification d'un thread avec aucun manquant", () => messaging.UpdateThread(null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Modification d'un thread avec paramètres manquant", () => messaging.UpdateThread({id_political_party: 2}).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Création d'un thread", () => messaging.AddThread({
        name: "LREM Thread", id_political_party: 3
    }).then((data) => expect(data).toMatchObject({
        status: 201
    })));
});

describe("Test récupération des Threads", () => {
    test("Récupération des thread avec des droits", () => messaging.GetThread("875543548").then((data) => expect(data).toMatchObject({
        status: 200
    })));
});

