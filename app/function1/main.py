from flask import jsonify

def main(request):
    return jsonify({
        "message": "Hello from Function 1",
        "timestamp": request.timestamp
    })
