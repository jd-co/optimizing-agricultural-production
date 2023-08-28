import json
from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

app = Flask(__name__)
CORS(app)

# Read the dataset
data = pd.read_csv('data.csv')

# Prepare the training data
x = data.drop('label', axis=1)
y = data['label']

x_train, x_test, y_train, y_test = train_test_split(x.values, y, test_size=0.2, random_state=0)


model=RandomForestClassifier(n_estimators=10,criterion='entropy')
model.fit(x_train, y_train)

@app.route('/', methods=['POST'])
def predict_crop():
    data = request.get_json()

    # Extract input values from the received JSON data
    nitrogen = float(data['nitrogen'])
    potassium = float(data['potassium'])
    phosphorus = float(data['phosphorus'])
    humidity = float(data['humidity'])
    temperature = float(data['temperature'])
    rainfall = float(data['rainfall'])
    ph = float(data['ph'])

    # Prepare the input data for prediction as a NumPy array
    input_data = np.array([[nitrogen, phosphorus, potassium, temperature, humidity, ph, rainfall]])

  
    predicted_crop = model.predict(input_data)[0]

    print("Input data:", input_data)
    print("Predicted crop:", predicted_crop)

    # Convert the predicted crop to a JSON response
    response = {
        'predicted_crop': predicted_crop
    }

    return json.dumps(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
