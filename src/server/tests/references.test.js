import references from "../controllers/references.controller.mjs";

describe("Test récupération des références", () => {
    test("Récupération des types d'étapes", () => references.GetTypeStep().then((data) => expect(data).toMatchObject({
        status: 200, data: [{
            "id": 1, "name": "Départ"
        }, {
            "id": 2, "name": "Etape"
        }, {
            "id": 3, "name": "Arrivée"
        }]
    })));

    test("Récupération des civilités", () => references.GetSex().then((data) => expect(data).toMatchObject({
        status: 200, data: [{
            "id": 1, "name": "Homme"
        }, {
            "id": 2, "name": "Femme"
        }]
    })));

    test("Récupération des types de vote", () => references.GetTypeVote().then((data) => expect(data).toMatchObject({
        status: 200
    })));

    test("Récupération des bords politiques", () => references.GetPoliticalEdge().then((data) => expect(data).toMatchObject({
        status: 200, data: [{
            "id": 1, "name": "Extrême gauche"
        }, {
            "id": 2, "name": "Gauche"
        }, {
            "id": 3, "name": "Centre gauche"
        }, {
            "id": 4, "name": "Centre droite"
        }, {
            "id": 5, "name": "Droite"
        }, {
            "id": 6, "name": "Extrême droite"
        }]
    })));
});
