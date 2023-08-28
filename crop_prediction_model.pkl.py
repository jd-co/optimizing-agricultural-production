import numpy as np
import pandas as pd
import joblib
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.model_selection import train_test_split

# Read the dataset
data = pd.read_csv('data.csv')

# Split the dataset into features (x) and labels (y)
x = data.drop(['label'], axis=1)
y = data['label']

# Split the data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=0)

# Train the logistic regression model
model = LogisticRegression()
model.fit(x_train, y_train)

# Evaluate the model performance
y_pred = model.predict(x_test)
cm = confusion_matrix(y_test, y_pred)
cr = classification_report(y_test, y_pred)

# Save the trained model as a .pkl file
joblib.dump(model, 'crop_prediction_model.pkl')

# Use the model to make a prediction
prediction = model.predict(np.array([[90, 40, 40, 20, 80, 7, 200]]))
print("The suggested crop for the given climatic conditions is:", prediction)
