from flask import Flask, request, jsonify
from flask_cors import CORS
from langchain.prompts import PromptTemplate
from langchain_openai import OpenAI
from langchain.chains import LLMChain
from PyPDF2 import PdfReader
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores import FAISS
from langchain.chains.question_answering import load_qa_chain
from langchain.llms import OpenAI
import os
import requests
import numpy as np
import string
import nltk
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
from transformers import DistilBertTokenizer, TFDistilBertModel
import pickle
import pandas as pd
import transformers
import keras_ocr
import keras

from keras.models import load_model
from keras.optimizers import Adam

app = Flask(__name__)
CORS(app)  # Enable CORS for the Flask app

def get_questions(difficulty_level, amount):
    url = "https://opentdb.com/api.php"
    params = {
        "amount": amount,
        "category": 17,
        "difficulty": difficulty_level
    }

    response = requests.get(url, params=params)
    data = response.json()

    print("Response data:", data)  # Print the response data for inspection

    if "results" in data:
        return data["results"]
    else:
        print("Error fetching questions:", data.get("message", "Unknown error"))
        return []

def map_grade_to_difficulty(grade):
    grade_to_difficulty = {
        "10th Grade": "hard",
        "11th Grade": "hard",
        "12th Grade": "hard"
    }

    return grade_to_difficulty.get(grade, "easy")  # Default to easy if grade not found

@app.route("/get_questions", methods=["POST"])
def fetch_questions():
    data = request.get_json()
    grade = data.get("grade")

    if not grade:
        return jsonify({"error": "Grade level not provided."}), 400

    difficulty_level = map_grade_to_difficulty(grade)
    questions = get_questions(difficulty_level, 8)  # Fetch 8 questions
    return jsonify({"questions": questions})

@app.route("/adaptive_easy", methods=["POST"])
def fetch_easy_questions():
    data = request.get_json()
    grade = data.get("grade")

    if not grade:
        return jsonify({"error": "Grade level not provided."}), 400

    standard_to_difficulty = {
        "10th Grade": ("easy", "medium", "hard"),
        "11th Grade": ("easy", "medium", "hard"),
        "12th Grade": ("easy", "medium", "hard")
    }

    if grade not in standard_to_difficulty:
        return jsonify({"error": "Invalid grade level."}), 400

    easy_questions = get_questions("easy", 10)  # Fetch 10 easy difficulty questions

    return jsonify({"questions": easy_questions})

@app.route("/adaptive_medium", methods=["POST"])
def fetch_medium_questions():
    data = request.get_json()
    grade = data.get("grade")

    if not grade:
        return jsonify({"error": "Grade level not provided."}), 400

    standard_to_difficulty = {
        "10th Grade": ("easy", "medium", "hard"),
        "11th Grade": ("easy", "medium", "hard"),
        "12th Grade": ("easy", "medium", "hard")
    }

    if grade not in standard_to_difficulty:
        return jsonify({"error": "Invalid grade level."}), 400

    medium_questions = get_questions("medium", 10)  # Fetch 10 medium difficulty questions

    return jsonify({"questions": medium_questions})

@app.route("/adaptive_hard", methods=["POST"])
def fetch_hard_questions():
    data = request.get_json()
    grade = data.get("grade")

    if not grade:
        return jsonify({"error": "Grade level not provided."}), 400

    standard_to_difficulty = {
        "10th Grade": ( "hard"),
        "11th Grade": ( "hard"),
        "12th Grade": ( "hard")
    }

    if grade not in standard_to_difficulty:
        return jsonify({"error": "Invalid grade level."}), 400

    hard_questions = get_questions("hard", 10)  # Fetch 10 hard difficulty questions

    return jsonify({"questions": hard_questions})

# OpenAI configuration
os.environ['OPENAI_API_KEY'] = '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'

# Define prompt template for question answering
template = '''
{text}

Grade these questions and answers and give a final score out of 10
give the score as output only nothing else in the format score'''

prompt = PromptTemplate(
    input_variables=['text'],
    template=template
)

stopwords = nltk.corpus.stopwords.words('english')
lemmatizer = WordNetLemmatizer()
tokenizer_bert = DistilBertTokenizer.from_pretrained('distilbert-base-uncased')
def load_custom_model(filepath):
    model = load_model(filepath, custom_objects={
        'DistilBertTokenizer': DistilBertTokenizer,
        'TFDistilBertModel': TFDistilBertModel
    },compile=False)
    
    # Change the optimizer to use compatible settings
    optimizer = Adam()
    model.compile(optimizer=optimizer, loss='binary_crossentropy', metrics=['accuracy'])
    
    return model

model = load_custom_model('/home/yuvraj/Coding/Innov8/automatedGrader/best_model.h5')


# Initialize OpenAI and LLMChain
llm = OpenAI(temperature=0.6)
chain1 = LLMChain(llm=llm, prompt=prompt)

# Function to fetch quiz questions from the API
def fetch_quiz_questions(difficulty, topic):
    url = f"https://opentdb.com/api.php?amount=5&difficulty={difficulty}&category={topic}&type=multiple"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()["results"]
    else:
        print("Failed to fetch quiz questions.")
        return []

# Function to fetch available categories from the API
def fetch_categories():
    url = "https://opentdb.com/api_category.php"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()["trivia_categories"]
    else:
        print("Failed to fetch categories.")
        return []

# Function to clean the text
def clean_text(text):
    text = str(text)
    tokens = word_tokenize(text)
    tokens[0] = tokens[0][2:]  # Remove the first two characters from the first token
    cleaned_text = [lemmatizer.lemmatize(word.lower()) for word in tokens if word.lower() not in stopwords and word not in string.punctuation]
    return ' '.join(cleaned_text)

# Function to make predictions asynchronously
async def predict_async(text):
    tokenized_text = tokenizer_bert.encode(clean_text(text), padding='max_length', max_length=512, truncation=True, return_tensors='tf')
    prediction = model.predict(tokenized_text)
    return int(np.argmax(prediction[0]))

# Flask API endpoint to grade questions and answers
@app.route('/grade', methods=['POST'])
def grade():
    data = request.get_json()
    question = data['question']
    answer = data['answer']
    questions_answers = f'Q:"{question}"\nAnswer:{answer}'
    output = chain1.invoke(questions_answers)
    score = output['text']
    return jsonify({'score': score})

# Function to analyze PDF
def analyze_pdf(pdf):
    pdfreader = PdfReader(pdf)
    raw_text = ''
    for i, page in enumerate(pdfreader.pages):
        content = page.extract_text()
        if content:
            raw_text += content
    text_splitter = CharacterTextSplitter(
        separator="\n",
        chunk_size=800,
        chunk_overlap=200,
        length_function=len,
    )
    texts = text_splitter.split_text(raw_text)
    embeddings = OpenAIEmbeddings()

    document_search = FAISS.from_texts(texts, embeddings)

    chain = load_qa_chain(OpenAI(), chain_type="stuff")
    query = "summarize the document in 200 words"
    docs = document_search.similarity_search(query)
    analysis = chain.run(input_documents=docs, question=query)
    return analysis

@app.route('/analyze_pdf', methods=['POST'])
def analyze_pdf_endpoint():
    # Check if a file was uploaded
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400
    
    file = request.files['file']
    
    # Check if the file is a PDF
    if file.filename.endswith('.pdf'):
        analysis = analyze_pdf(file)
        return jsonify(analysis)
    else:
        return jsonify({'error': 'File is not a PDF'}), 400

# Flask API endpoint to predict text asynchronously
@app.route('/predict', methods=['POST'])
async def predict_text():
    data = request.get_json()
    text = data['text']
    prediction = await predict_async(text)
    return jsonify({'prediction': prediction})


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

@app.route('/predict_changes', methods=['POST'])
def predict():
    data = request.get_json()
    df = pd.DataFrame(data)
    model=loaded_model
    g3=model.predict(df)[0]
    changes=predict_changes(df,g3)
    return jsonify({"possible_changes": changes})

if __name__ == '__main__':
    app.run(debug=True)

