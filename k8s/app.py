from fastapi import FastAPI
from transformers import AutoModelForCausalLM, AutoTokenizer
import uvicorn


app = FastAPI()

#model_name = "databricks/dolly-v2-3b"
model_name = "microsoft/DialoGPT-small"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)


@app.get("/")
def root():
    return {"message": "Dolly v2 3b API"}

@app.post("/generate")
def generate(prompt: str):
    inputs = tokenizer.encode(prompt, return_tensors="pt")
    outputs = model.generate(inputs, max_length=100, num_return_sequences=1)
    generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {"prompt": prompt, "generated_text": generated_text}


if __name__ == "__main__":
    # tokenizer = AutoTokenizer.from_pretrained(model_name)
    # model = AutoModelForCausalLM.from_pretrained(model_name)
    uvicorn.run(app, host="0.0.0.0", port=80)    