from flask import Blueprint, request, jsonify
import os
from models import db, File, AuditTrail
from datetime import datetime

file_bp = Blueprint('file', __name__)
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@file_bp.route('/upload', methods=['POST'])
def upload_file():
    f = request.files['file']
    path = os.path.join(UPLOAD_FOLDER, f.filename)
    f.save(path)
    new_file = File(filename=f.filename, filepath=path, uploaded_by=1)
    db.session.add(new_file)

    audit = AuditTrail(user_id=1, action="Uploaded file", timestamp=datetime.now())
    db.session.add(audit)

    db.session.commit()
    return jsonify({"message": "File uploaded successfully"})

@file_bp.route('/files', methods=['GET'])
def list_files():
    try:
        files = os.listdir(current_app.config['UPLOAD_FOLDER'])
        return jsonify({'files': files}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
