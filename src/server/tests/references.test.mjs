import references from "../controllers/references.controller.mjs";
import manifestation from "../controllers/manifestation.controller.mjs";

describe("Test récupération des références", () => {
    test("Récupération des types d'étapes", () => manifestation.GetAllManifestations(false, null).then((data) => expect(data).toMatchObject({
        status: 200, data: [{
            "id": 1, "name": "Départ"
        }, {
            "id": 2, "name": "Etape"
        }, {
            "id": 3, "name": "Arrivée"
        }]
    })));
});
