import party from "../controllers/party.controller.mjs";

describe("Test ajout d'un parti politique", () => {
    test("Ajout d'un parti avec paramètres manquants", () => party.AddParty(null).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    test("Ajout d'un parti qui n'existe pas chez l'INSEE", () => party.AddParty({
        siren: "test", url_logo: "test", object: "test", id_political_edge: 2, nir: "875543548"
    }).then((data) => expect(data).toMatchObject({status: 404, data: "This political party does not exists."})));
    test("Ajout d'un parti qui existe déjà", () => party.AddParty({
        siren: "819004045", url_logo: "test", object: "test", id_political_edge: 2, nir: "875543548"
    }).then((data) => expect(data).toMatchObject({status: 400, data: "This political party already existed."})));
});
