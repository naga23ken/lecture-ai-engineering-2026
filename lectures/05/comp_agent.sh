#!/bin/bash

# QUESTION="第2回の説明では、LoRAは何を固定し何を学習しますか？ QLoRAは何を加えますか？"
# QUESTION="ファインチューニングの効果と欠点は？"
QUESTION="ハーネスによるチューニングと、ファインチューニングの違いと、それぞれの利点・欠点を教えて。"

export AIE_MODEL=gemini-3.1-flash-lite


echo uv run python -m app.agent --full-context --trace "$QUESTION"
echo '```shell'
uv run python -m app.agent --full-context --trace "$QUESTION"
echo '```'
echo 

# sleep 20

# echo uv run python -m app.agent --trace "$QUESTION"
# echo '```shell'
# uv run python -m app.agent --trace "$QUESTION"
# echo '```'
# echo

# sleep 10

# echo uv run python -m app.agent --tree --trace "$QUESTION"
# echo '```shell'
# uv run python -m app.agent --tree --trace "$QUESTION"
# echo '```'
# echo

# sleep 10

# echo uv run python -m app.agent --graph --trace "$QUESTION"
# echo '```shell'
# uv run python -m app.agent --graph --trace "$QUESTION"
# echo '```'

# sleep 10

