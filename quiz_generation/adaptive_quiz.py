import requests

def get_questions(difficulty_level, amount):
    """
    Fetches questions from the OpenTDB API based on the provided difficulty (easy, medium, hard) and amount.

    Args:
        difficulty_level (str): The desired difficulty level ("easy", "medium", or "hard").
        amount (int): The desired number of questions.

    Returns:
        list: A list of dictionaries containing question data (category, type, difficulty, question, correct_answer, incorrect_answers).
    """

    url = "https://opentdb.com/api.php"
    params = {
        "amount": amount,
        "category": 17,
        "difficulty": difficulty_level
    }

    response = requests.get(url, params=params)
    data = response.json()

    if data["response_code"] == 0:
        return data["results"]
    else:
        print("Error fetching questions:", data["results"])
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

def main():
    """
    The main function that handles user interaction, question selection, and scoring.
    """

    standard_to_difficulty = {
        "10th Grade": ("easy", "medium", "hard"),
        "11th Grade": ("easy", "medium", "hard"),
        "12th Grade": ("easy", "medium", "hard")
    }

    print("Welcome to the Adaptive Quiz App!")
    standard = input("Enter your grade level (e.g., 10th Grade, 11th Grade, 12th Grade): ")

    if standard not in standard_to_difficulty:
        print("Invalid grade level. Please try again.")
        return

    difficulty_levels = standard_to_difficulty[standard]

    score = {"easy": 0, "medium": 0, "hard": 0}
    questions_count = {"easy": 0, "medium": 0, "hard": 0}

    for difficulty in difficulty_levels:
        print(f"\nDifficulty: {difficulty.capitalize()}")
        questions = get_questions(difficulty, 10)  # Adjust the number of questions here

        for question in questions:
            questions_count[difficulty] += 1
            display_question(question)
            user_answer = input("Enter your answer (number): ")

            try:
                user_answer_int = int(user_answer) - 1  # Convert to 0-based index
                if user_answer_int == question["correct_answer_index"]:
                    score[difficulty] += 1
                    print("Correct!")
                else:
                    print("Incorrect. The correct answer was:", question["correct_answer"])
            except ValueError:
                print("Invalid input. Please enter a number.")

    print("\nYour final score:")
    for difficulty, count in questions_count.items():
        print(f"{difficulty.capitalize()}: {score[difficulty]}/{count}")


if __name__ == "__main__":
    main()
