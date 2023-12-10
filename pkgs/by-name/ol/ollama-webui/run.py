import uvicorn
from ollama_webui.main import app

def run():
    uvicorn.run("ollama_webui.main:app", host="0.0.0.0", port=8080)

if __name__ == "__main__":
    run()
