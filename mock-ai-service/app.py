from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/hello")
async def read_root():
    return {
        "id": "chatcmpl-123",
        "object": "chat.completion",
        "created": 1677652288,
        "model": "fastapi-mock-v1",
        "choices": [
            {
                "index": 0,
                "message": {
                    "role": "assistant",
                    "content": "Hello! This is a mock AI response from the local FastAPI service.",
                },
                "finish_reason": "stop"
            }
        ],
        "usage": {
            "prompt_tokens": 9,
            "completion_tokens": 12,
            "total_tokens": 21
        }
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5001)
