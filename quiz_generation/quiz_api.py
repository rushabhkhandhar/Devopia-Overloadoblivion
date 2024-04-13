from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

def get_questions(difficulty_level):
    """
    Fetches questions from the OpenTDB API based on the provided difficulty (easy, medium, hard).

    Args:
        difficulty_level (str): The desired difficulty level ("easy", "medium", or "hard").

    Returns:
        list: A list of dictionaries containing question data (question, correct_answer, incorrect_answers).
    """

    url = "https://opentdb.com/api.php"
    params = {
        "amount": 8,    
        "category": 17,  
        "difficulty": difficulty_level
    }

    response = requests.get(url, params=params)
    data = response.json()

    if data["response_code"] == 0:
        # Extract question, correct answer, and incorrect answers data
        questions = []
        for result in data["results"]:
            question = {
                "question": result["question"],
                "correct_answer": result["correct_answer"],
                "incorrect_answers": result["incorrect_answers"]
            }
            questions.append(question)
        return questions
    else:
        print("Error fetching questions:", data["results"])
        return [] 

def map_grade_to_difficulty(grade):
    """
    Maps grade levels to difficulty levels.

    Args:
        grade (str): The grade level.

    Returns:
        str: The difficulty level ("easy", "medium", or "hard").
    """

    grade_to_difficulty = {
        "10th Grade": "hard",
        "11th Grade": "hard",
        "12th Grade": "hard"
    }

    return grade_to_difficulty.get(grade, "easy")  # Default to easy if grade not found

@app.route("/get_questions", methods=["POST"])
def fetch_questions():
    """
    Fetches questions based on the provided grade level.
    Expects JSON input with the grade level.

    Returns:
        JSON: A JSON response containing the questions.
    """

    data = request.get_json()
    grade = data.get("grade")

    if not grade:
        return jsonify({"error": "Grade level not provided."}), 400

    difficulty_level = map_grade_to_difficulty(grade)
    questions = get_questions(difficulty_level)
    return jsonify({"questions": questions})

if __name__ == "__main__":
    app.run(debug=True)
