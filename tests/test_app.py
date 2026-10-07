"""Tests for the sample service."""

import json
import threading
from http.server import HTTPServer

import pytest
from main import HealthHandler


@pytest.fixture(scope="module")
def server():
    srv = HTTPServer(("127.0.0.1", 0), HealthHandler)
    t = threading.Thread(target=srv.serve_forever, daemon=True)
    t.start()
    yield f"http://127.0.0.1:{srv.server_port}"
    srv.shutdown()


def test_health(server):
    import urllib.request
    with urllib.request.urlopen(f"{server}/health") as r:
        assert r.status == 200
        body = json.loads(r.read())
    assert body["status"] == "healthy"


def test_root(server):
    import urllib.request
    with urllib.request.urlopen(f"{server}/") as r:
        assert r.status == 200
        assert b"running in" in r.read()


def test_unknown_path_404(server):
    import urllib.error
    import urllib.request
    with pytest.raises(urllib.error.HTTPError) as exc:
        urllib.request.urlopen(f"{server}/nope")
    assert exc.value.code == 404
