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
        address_street : "23 avenue du Générale De Gaulle",
        date_arrived: "2019-10-02 08:10",
        id_manifestation: 1,
        id_step_type: 1,
        town_code_insee: "11003"
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

};
