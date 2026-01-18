from flask import Flask, jsonify
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app) # Enable Cross-Origin Resource Sharing for the frontend

# Mock Data - In real P&A, this comes from a Database
parts_inventory = [
    {"id": "MZ-101", "name": "Mazda 3 Brake Pad Set", "price": 45.99, "stock": 120},
    {"id": "MZ-102", "name": "CX-5 Oil Filter", "price": 12.50, "stock": 500},
    {"id": "MZ-103", "name": "MX-5 Spark Plug", "price": 8.99, "stock": 200},
    {"id": "MZ-104", "name": "Mazda 6 Air Filter", "price": 22.00, "stock": 80},
    {"id": "MZ-200", "name": "SkyActiv Engine Oil (5L)", "price": 55.00, "stock": 30}
]

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "service": "inventory-api"}), 200

@app.route('/api/parts', methods=['GET'])
def get_parts():
    return jsonify(parts_inventory)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)