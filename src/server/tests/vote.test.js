import voteCtrl from "../controllers/vote.controller.mjs";

describe("Test ajout d'un vote", () => {
    test("Ajout d'un vote sans paramètres", () => voteCtrl.AddVote(null).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    test("Ajout d'un vote avec paramètres manquant", () => voteCtrl.AddVote({
        name: "test", date_start: '2022-05-12'
    }).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    test("Ajout d'un vote avec un mauvais type vote", () => voteCtrl.AddVote({
        name: "test", date_start: '2022-05-12', date_end: '2022-05-12', num_round: 2, id_type_vote: 9, nb_voter: 20000,
    }).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters about the type of vote selected."
    })));
    test("Ajout d'un vote avec un type vote incomplet", () => voteCtrl.AddVote({
        name: "test",
        date_start: "2022-05-12",
        date_end: "2022-05-12",
        num_round: 2,
        id_type_vote: voteCtrl.EnumTypeVote.Regional,
        nb_voter: 20000,
    }).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters about the type of vote selected."
    })));
    test("Ajout d'un vote", () => voteCtrl.AddVote({
        name: "test",
        date_start: new Date(),
        date_end: new Date(),
        num_round: 2,
        id_type_vote: voteCtrl.EnumTypeVote.Presidentiel,
        nb_voter: 20000,
    }).then((data) => expect(data).toMatchObject({status: 201, data: "Vote has been created."})));
});
