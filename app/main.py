import os
from datetime import datetime, timezone

from flask import Flask, jsonify


def create_app() -> Flask:
    """Cria e configura a aplicação Flask."""

    app = Flask(__name__)

    @app.get("/")
    def home():
        return jsonify(
            {
                "application": "flask-devops-api",
                "message": "API DevOps funcionando com sucesso!",
                "environment": os.getenv("APP_ENV", "development"),
                "status": "success",
                "timestamp": datetime.now(timezone.utc).isoformat(),
            }
        ), 200

    @app.get("/health")
    def health():
        return jsonify(
            {
                "application": "flask-devops-api",
                "status": "healthy",
            }
        ), 200

    @app.get("/version")
    def version():
        return jsonify(
            {
                "application": "flask-devops-api",
                "version": os.getenv("APP_VERSION", "1.0.0"),
            }
        ), 200

    @app.errorhandler(404)
    def not_found(_error):
        return jsonify(
            {
                "error": "Endpoint não encontrado",
                "status": "error",
            }
        ), 404

    return app


app = create_app()


if __name__ == "__main__":
    port = int(os.getenv("PORT", "5000"))

    app.run(
        host="0.0.0.0",
        port=port,
        debug=False,
    )