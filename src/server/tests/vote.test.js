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
        id_type_vote: 8
    }).then((data) => expect(data).toMatchObject({status: 201, data: "Vote has been created."})));
});

describe("Test ajout d'un tour de vote", () => {
    test("Ajout d'un tour sans paramètres", () => voteCtrl.AddRound(null, null).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    test("Ajout d'un tour avec paramètres manquant", () => voteCtrl.AddRound({name: "test"}, 1).then((data) => expect(data).toMatchObject({
        status: 400, data: "Missing parameters."
    })));
    test("Ajout d'un tour", () => voteCtrl.AddRound({
        name: "test",
        date_start: "2022-12-12 08:00",
        date_end: "2022-12-12 20:00",
        num: 1,
        nb_voter: 20000,
    }, 1).then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

describe("Test récupération des votes", () => {
    test("Récupération des votes", () => voteCtrl.GetVote("875543548").then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

describe("Test récupération des tours de votes", () => {
    test("Récupération des tours de votes", () => voteCtrl.GetRound("875543548").then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

