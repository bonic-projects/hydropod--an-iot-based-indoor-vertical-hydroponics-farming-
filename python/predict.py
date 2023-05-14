from firebase_admin import credentials, initialize_app, db
import csv
import pickle
import pandas as pd

# Set the credentials to access Firebase
cred = credentials.Certificate('hydropod-12ef6-firebase-adminsdk-zf3lf-1c96d35628.json')
# Initialize the app with a custom database URL
options = {
    'databaseURL': 'https://hydropod-12ef6-default-rtdb.asia-southeast1.firebasedatabase.app/'
}

initialize_app(cred, options)

# Get a reference to the database service
ref = db.reference("/devices/PhHdzpmj4xUZT6wWELcs1FroV513/reading/")
conditionRef = db.reference("/devices/PhHdzpmj4xUZT6wWELcs1FroV513/reading2/")

# Define the CSV file name and header row
csv_file = 'hydropod_data.csv'
header = ['ph', 'temp', 'ec', 'water_level', 'condition']

def predict(data):
    with open('hydropod_model.pkl', 'rb') as mod_file:
        mlp = pickle.load(mod_file)
    # Enter the 18 features as input
    df = pd.DataFrame(data=[data], columns=header)
    res = mlp.predict(df)[0]
    if (res == 0):
        print("Bad condition")
    else:
        print("Good condition")
    return res

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
        res = predict(row)
        conditionRef.update({"condition": False if res == 0 else True})
ref.listen(on_data_change)

