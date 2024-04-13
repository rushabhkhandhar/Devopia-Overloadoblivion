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
        "10th Grade": ( "medium"),
        "11th Grade": ("medium"),
        "12th Grade": ("medium")
    }

    if grade not in standard_to_difficulty:
        return jsonify({"error": "Invalid grade level."}), 400

    medium_questions = get_questions("medium", 10)  

    return jsonify({"questions": medium_questions})


if __name__ == "__main__":
    app.run(debug=True)
