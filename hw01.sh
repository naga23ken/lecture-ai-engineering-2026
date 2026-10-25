echo "---"
echo "# 4回目の試行"

export AIE_MODEL="gemini-3.5-flash-lite"
echo "## CASE01: 使用するモデル: $AIE_MODEL"
uv run python -m app.ask 
echo ""
sleep 10

export AIE_MODEL="gemini-3.1-flash-lite"
echo "## CASE02: 使用するモデル: $AIE_MODEL"
uv run python -m app.ask 
echo ""
sleep 10

export AIE_MODEL="gemini-3.5-flash"
echo "## CASE03: 使用するモデル: $AIE_MODEL"
uv run python -m app.ask 
echo ""