from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

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


def display_question(question_data):
    """
    Presents a quiz question and answer options to the user.

    Args:
        question_data (dict): A dictionary containing question data.
    """

    print(question_data["question"])
    for i, option in enumerate(question_data["incorrect_answers"]):
        print(f"{i+1}. {option}")
    print(f"{len(question_data['incorrect_answers']) + 1}. {question_data['correct_answer']}")

    # Add the index of the correct answer to the question_data dictionary
    question_data["correct_answer_index"] = len(question_data['incorrect_answers'])

@app.route("/adaptive_easy", methods=["POST"])
def fetch_questions():
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

    all_questions = []
    for difficulty in standard_to_difficulty[grade]:
        questions = get_questions(difficulty, 10)  # Adjust the number of questions here
        all_questions.extend(questions)

    return jsonify({"questions": all_questions})


if __name__ == "__main__":
    app.run(debug=True)
