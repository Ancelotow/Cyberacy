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
    test("Récupération des thread avec des droits", () => messaging.GetThread("875543548", false).then((data) => expect(data).toMatchObject({
        status: 200
    })));
    test("Récupération des thread sans droits", () => messaging.GetThread("541397454", false).then((data) => expect(data).toMatchObject({
        status: 204
    })));
});

describe("Test récupération des Messages", () => {
    test("Récupération des messages", () => messaging.GetMessage("875543548", 29).then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

describe("Test publication d'un Messages", () => {
    test("Publication d'un message avec paramètres manquants", () => messaging.AddMessage("875543548", 29, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Publication d'un message avec un non-membre du thread", () => messaging.AddMessage("987465257", 29, "Message test").then((data) => expect(data).toMatchObject({
        status: 400,
        data: "You are not in this thread."
    })));
    test("Publication d'un message", () => messaging.AddMessage("875543548", 29, "Message test").then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

