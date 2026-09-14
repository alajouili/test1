import sys
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parents[1]))

from app import app

def test_hello():
    client = app.test_client()
    response = client.get('/')
    assert response.status_code == 200
    assert b"Hello from inside a Docker Container!" in response.data