import meeting from "../controllers/meeting.controller.mjs";

describe("Test récupération des meetings", () => {
    test("Récupération des meetings", () => meeting.GetMeeting().then((data) => expect(data).toMatchObject({
        status: 200
    })));
});

describe("Test ajout d'un meeting", () => {
    test("Ajout avec aucun meeting", () => meeting.AddMeeting(null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout avec paramètre manquant", () => meeting.AddMeeting({
        name: "Présidentiel 2022",
    }).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Ajout d'un meeting", () => meeting.AddMeeting({
        name: "Présidentiel 2022",
        object: "Présidentiel",
        date_start: "2022-05-12",
        nb_time: 2.20,
        id_political_party: 3
    }).then((data) => expect(data).toMatchObject({
        status: 201
    })));
})

describe("Test annulation d'un meeting", () => {
    test("Annulation avec paramètres manquants", () => meeting.AbortedMeeting(null, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Annulation d'un meeting inexistant", () => meeting.AbortedMeeting(1000, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Annulation d'un meeting", () => meeting.AbortedMeeting(1, "Parceque !!").then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

describe("Test participer à un meeting", () => {
    test("Participation avec paramètres manquants", () => meeting.AddParticipant(null, null).then((data) => expect(data).toMatchObject({
        status: 400
    })));
    test("Participation à un meeting", () => meeting.AddParticipant("875543548", 1).then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
    test("Annulation de la participation à un meeting", () => meeting.AbortedParticipant(1, 1, "Parce que !").then((data) => expect(data).not.toMatchObject({
        status: 500
    })));
});

