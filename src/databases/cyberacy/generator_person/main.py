import json
import csv
import psycopg2
from psycopg2.extras import RealDictCursor
import names
import random


class Person:

    def __init__(self, town_code):
        fullname = names.get_full_name()
        self.name = fullname.split(' ')[0]
        self.firstname = fullname.split(' ')[1]
        self.email = "%s.%s@yopmail.com" % (self.name, self.firstname)
        self.sex = random.randint(1, 2)
        self.nir = random.randint(10000000000, 19999999999)
        self.town_code = town_code


def get_connection():
    host = "cyberacy.postgres.database.azure.com"
    dbname = "cyberacy"
    user = "cyberacy"
    password = "7sA9h5Uc5TyT"
    return psycopg2.connect("host=%s dbname=%s user=%s password=%s" % (host, dbname, user, password))


def get_all_town():
    results_town = []
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            request = '''SELECT * FROM town WHERE dpt_code = '75' '''
            cursor.execute(request)
            results_town = cursor.fetchall()
        conn.commit()
    return results_town


def main():
    list_towns = get_all_town()
    list_persons = []
    index = 0
    for town in list_towns:
        for i in range(0, town["twn_nb_resident"]):
            index += 1
            list_persons.append(Person(town["twn_code_insee"]).__dict__)
            print(index)
    keys = list_persons[0].keys()
    with open("persons.csv", "a") as file:
        dict_writer = csv.DictWriter(file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(list_persons)


if __name__ == "__main__":
    print("=============== START ===============")
    main()
    print("=============== END ===============")
