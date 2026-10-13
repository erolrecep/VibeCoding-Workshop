import sys
import os

# Ensure the root 2048 application directory is in sys.path
app_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if app_root not in sys.path:
    sys.path.insert(0, app_root)

def main() -> None:
    from app import main as run_app
    run_app()

__all__ = ["main"]
