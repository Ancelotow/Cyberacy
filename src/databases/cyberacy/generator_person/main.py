import json
import csv
from multiprocessing import Process

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
            request = '''SELECT * FROM town WHERE dpt_code = '01' '''
            cursor.execute(request)
            results_town = cursor.fetchall()
        conn.commit()
    return results_town


def insert_person(town):
    list_persons = []
    for i in range(0, town["twn_nb_resident"]):
        list_persons.append(Person(town["twn_code_insee"]).__dict__)
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            request = '''
                INSERT INTO person(prs_nir, prs_firstname, prs_lastname, prs_email, twn_code_insee, sex_id) 
                VALUES(%(nir)s, %(firstname)s, %(name)s, %(email)s, %(town_code)s, %(sex)s)          
            '''
            cursor.executemany(request, tuple(list_persons))
            print(town["twn_name"])
        conn.commit()


def main():
    list_towns = get_all_town()
    list_tasks = []
    for town in list_towns:
        task = Process(target=insert_person, args=(town, ))
        task.start()
        list_tasks.append(task)
    for task in list_tasks:
        task.join()


if __name__ == "__main__":
    print("=============== START ===============")
    main()
    print("=============== END ===============")
