export default  {

    Connection: {
        nir: "012457832032045",
        password: "azerty1234!",
    },

    Person: {
        nir: "012457832032045",
        firstname: "Ronald",
        lastname: "TOLKIEN",
        email: "test@gmail.com",
        password: "azerty1234!",
        birthday: "1998-05-23",
        address_street: "39 rue des rosiers",
        town_code_insee: "11003",
        sex: 1,
        profile: 1
    },

    AddManifestation: {
        name: "Les gilets jaunes",
        date_start: "2019-10-02 08:00",
        date_end: "2019-10-02 20:00",
        object: "Gilets Jaunes",
        security_description: "Police",
        nb_person_estimate: 2000
    },

    Aborted: {
        id: 1,
        reason: "Orage de prévu"
    },

    AddOptionManifestation: {
        name: "Hauts-parleurs",
        description: "Hauts-parleurs afin de diffuser de la musique et le discours des organisateurs",
        id_manifestation: 1
    },

    AddStepManifestation: {
        address_street : "6 parvis de Notre-Dame - Pl. Jean-Paul II",
        date_arrived: "2019-10-02 08:10",
        id_manifestation: 1,
        id_step_type: 1,
        town_code_insee: "75104",
        latitude: 48.8535738,
        longitude: 2.3514893
    },

    AddVote: {
        name: "Présidentiel 2022",
        id_type_vote: 1,
        town_code_insee: "11003",
        department_code: "94",
        reg_code_insee: "1",
        id_political_party: 1,
    },

    AddRoundVote: {
        name: "Présidentiel 2022 : 29/04/2022",
        num: 1,
        date_start: "2022-04-29 08:00",
        date_end: "2022-04-29 20:00",
        nb_voter: 58000000,
    },

    AddPoliticalParty: {
        name: "Horizon",
        date_create: "2021-10-05",
        description: "Nouveau parti politique d'Edouard Philippe",
        object: "Partie polique Horizon",
        address_street: "23 avenu Jules Vernes",
        siren: "254587",
        chart: "Règle n°1: Il est interdit de parler du fight club.\n Règle n°2 : Il est interdit de parler du fight club",
        iban: "FR78778ADA",
        id_political_edge: 1,
        nir: "012457832032045",
        town_code_insee: "11003"
    },

    AddAnnualFee: {
        year: 2022,
        id_political_party: 1,
        fee: 20.99
    },

    AddMeeting: {
        name: "Présidentielle 2022 : Bercy !",
        object: "élections présidentielles 2022",
        description: "Meeting pour préparer les élections présidentielles 2022 à l'Accord Hotel Arena",
        date_start: "2022-01-20 17:45",
        nb_time: 2.75,
        nb_place: 5000,
        street_address: "Accord Hotel Arena",
        link_twitch: "https://www.twitch.tv/samueletienne",
        id_political_party: 1,
        town_code_insee: "11003"
    },

    AddThread: {
        name: "Chat législative 2022",
        description: "Discussion concernant les législatives de Juin 2022",
        is_private: true,
        id_political_party: 1
    },

    UpdateThread: {
        id: 1,
        name: "Chat législative 2022",
        description: "Discussion concernant les législatives de Juin 2022",
        is_private: true,
        id_political_party: 1
    },

    AddChoice: {
        name: "Edouard PHILLIPE",
        choice_order: 1,
        description: "Elections aux législatives : Edouard PHILLIPE",
        candidat_nir: "012457832032045"
    },

};
