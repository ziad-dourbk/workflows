import platform
from flask import jsonify
from datetime import datetime

def main(request):
    return jsonify({
        "message": "Hello from Function 2",
        "system": platform.system(),
        "python_version": platform.python_version(),
        "timestamp": datetime.now().isoformat()
    })
