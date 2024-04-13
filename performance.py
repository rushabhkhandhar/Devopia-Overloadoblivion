import pickle
import pandas as pd
from flask import Flask, request,jsonify
import pandas as pd

# Load the model using pickle
with open('/home/yuvraj/Coding/devopia/my_model.pkl', 'rb') as f:
    loaded_model = pickle.load(f)

app = Flask(__name__)

changing_columns=['internet','romantic','paid','activities','studytime','freetime','traveltime','goout','absences']
binary_columns=['internet','romantic','paid','activities']
def predict_changes(df,g3):
    model=loaded_model
    df_copy=df.copy()
    pos_changes=[]
    for column in changing_columns:
        df_copy=df
        if column in binary_columns:
            if df_copy.at[0,column]==1:
                df_copy.at[0,column]=0
                predicted_g3=model.predict(df_copy)[0]
                print(f"Predicted g3 for {column}_inv: {predicted_g3}")
                if(predicted_g3>g3):
                    pos_changes.append(column+"_inv")
                else:
                    pos_changes.append(column)
            else:
                df_copy.at[0,column]=1
                predicted_g3=model.predict(df_copy)[0]
                print(f"Predicted g3 for {column}: {predicted_g3}")
                if(predicted_g3>g3):
                    pos_changes.append(column)
                else:
                    pos_changes.append(column+"inv")

    pos_changes+=[column for column in changing_columns if column not in binary_columns]
    return pos_changes

# data = pd.DataFrame({'age': [18],
#                          'Medu': [1],
#                          'Fedu': [1],
#                          'traveltime': [2],
#                          'studytime': [2],
#                          'failures': [0],
#                          'paid': [1],
#                          'activities': [1],
#                          'higher': [1],
#                          'internet': [1],
#                          'romantic': [0],
#                          'freetime': [3],
#                          'goout': [3],
#                          'absences': [4],
#                          'sex_F': [0],
#                          'sex_M': [1],
#                          'Mjob_at_home': [0],
#                          'Mjob_health': [0],
#                          'Mjob_other': [0],
#                          'Mjob_services': [1],
#                          'Mjob_teacher': [0],
#                          'Fjob_at_home': [0],
#                          'Fjob_health': [0],
#                          'Fjob_other': [0],
#                          'Fjob_services': [1],
#                          'Fjob_teacher': [0]})

@app.route('/predict_changes', methods=['POST'])
def predict():
    data = request.get_json()
    df = pd.DataFrame(data)
    model=loaded_model
    g3=model.predict(df)[0]
    changes=predict_changes(df,g3)
    return jsonify({"possible_changes": changes})

if __name__ == '__main__':
    app.run()

