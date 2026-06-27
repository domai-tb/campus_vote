import csv
import random
import string

# Funktion zur Generierung einer zufälligen Matrikelnummer (12-stellig)
def generate_matrikelnummer():
    return ''.join(random.choices(string.digits, k=12))

# Funktion zur Generierung eines zufälligen Vornamens
def generate_vorname():
    vornamen = ["Anna", "Max", "Lisa", "Paul", "Julia", "Leon", "Mia", "Lukas", "Emma", "Jonas"]
    return random.choice(vornamen)

# Funktion zur Generierung eines zufälligen Nachnamens
def generate_nachname():
    nachnamen = ["Müller", "Schmidt", "Meier", "Schneider", "Fischer", "Weber", "Meyer", "Wagner", "Becker", "Hoffmann"]
    return random.choice(nachnamen)

# Funktion zur Generierung einer Fakultät
def generate_fakultaet():
    fakultaeten = ["Informatik", "Wirtschaft", "Maschinenbau", "Medizin", "Physik", "Chemie", "Mathematik", "Psychologie"]
    return random.choice(fakultaeten)

# Funktion zur Generierung eines zufälligen Senatswahlkreises (römische Zahl von 1 bis 4)
def generate_senatswahlkreis():
    senatswahlkreise = ["I", "II", "III", "IV"]
    return random.choice(senatswahlkreise)

# Pfad der CSV-Datei
csv_datei = "../campusvote/voter_sample.csv"

# Header der CSV-Datei
header = ["Matrikelnummer", "Vorname", "Nachname", "Urne", "Fakultät", "Senatswahlkreis"]

# Erstelle eine CSV-Datei und schreibe die Daten
with open(csv_datei, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(header)
    
    # Generiere 40.000 Datensätze
    for _ in range(40000):
        matrikelnummer = generate_matrikelnummer()
        vorname = generate_vorname()
        nachname = generate_nachname()
        urne = "MA"  # Konstant
        fakultät = generate_fakultaet()
        senatswahlkreis = generate_senatswahlkreis()
        
        # Schreibe den Datensatz in die CSV-Datei
        writer.writerow([matrikelnummer, vorname, nachname, urne, fakultät, senatswahlkreis])

print(f"CSV-Datei mit 40.000 Beispieldaten wurde erfolgreich erstellt: {csv_datei}")