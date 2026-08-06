from app.main import create_app


def create_test_client():
    app = create_app()
    app.config.update(TESTING=True)

    return app.test_client()


def test_home_endpoint():
    client = create_test_client()

    response = client.get("/")
    data = response.get_json()

    assert response.status_code == 200
    assert data["application"] == "flask-devops-api"
    assert data["status"] == "success"


def test_health_endpoint():
    client = create_test_client()

    response = client.get("/health")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status"] == "healthy"


def test_version_endpoint():
    client = create_test_client()

    response = client.get("/version")
    data = response.get_json()

    assert response.status_code == 200
    assert data["version"] == "1.0.0"


def test_not_found_endpoint():
    client = create_test_client()

    response = client.get("/endpoint-inexistente")
    data = response.get_json()

    assert response.status_code == 404
    assert data["status"] == "error"