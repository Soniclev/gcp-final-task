import os

import pytest


@pytest.fixture(autouse=True)
def setup_test_database():
    os.putenv("DATABASE", "sqlite:///./sql_app.test.db")
