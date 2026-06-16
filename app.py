from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "status": "Healthy",
        "message": "Welcome to our Production GitOps Application!",
        "environment": os.getenv("APP_ENV", "Development")
    })

if __name__ == '__main__':
    # Running on port 5000 inside the container
    app.run(host='0.0.0.0', port=5000)