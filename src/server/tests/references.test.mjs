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
        status: 200, data: [{
            "id": 1, "name": "Présidentiel"
        }, {
            "id": 2, "name": "Régional"
        }, {
            "id": 3, "name": "Départemental"
        }, {
            "id": 4, "name": "Municipal"
        }, {
            "id": 5, "name": "Législative"
        }, {
            "id": 6, "name": "Référundum"
        }]
    })));
});
