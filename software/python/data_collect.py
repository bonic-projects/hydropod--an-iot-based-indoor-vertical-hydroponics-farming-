from firebase_admin import credentials, initialize_app, db
import csv

# Set the credentials to access Firebase
cred = credentials.Certificate('F:\Autobonics\college\hydropod\python\hydropod-12ef6-firebase-adminsdk-zf3lf-1c96d35628.json')
# Initialize the app with a custom database URL
options = {
    'databaseURL': 'https://hydropod-12ef6-default-rtdb.asia-southeast1.firebasedatabase.app/'
}
initialize_app(cred, options)

# Get a reference to the database service
ref = db.reference("/devices/PhHdzpmj4xUZT6wWELcs1FroV513/reading/")

# Define the CSV file name and header row
csv_file = 'hydropod_data.csv'
header = ['ph', 'temp', 'ec', 'water_level', 'condition']

conditionIn = False
# Listen to the database changes
def on_data_change(event):
    print("New data")
    global conditionIn
    data = event.data
    if(data.get('condition')!=None):
        conditionIn = data.get('condition')
    row = [data.get('ph'), data.get('temp'), data.get('ec'), data.get('wtr_level'), conditionIn]
    if data.get('ph') != 0: # and data.get('ec') != 0: #and list(data.values()) != last_row:
        with open(csv_file, mode='a', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(row)
        print('Data saved to CSV:', row)
ref.listen(on_data_change)