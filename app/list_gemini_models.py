import os
from google import genai

def main():
    # 1. 環境変数 GEMINI_API_KEY が設定されているか確認
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("エラー: 環境変数 'GEMINI_API_KEY' が設定されていません。")
        print("export GEMINI_API_KEY='あなたのAPIキー' を実行してから再度お試しください。")
        return

    print("環境変数から API キーを読み込みました。利用可能なモデル一覧を取得中...\n")

    # 2. クライアントの初期化
    # 秘匿せずとも、OSの環境変数 'GEMINI_API_KEY' をクライアントが自動で読み込みます
    client = genai.Client()

    # 3. 利用可能なモデルのリストを取得して表示
    print(f"{'モデル名 (Name)':<35} | {'サポートされている機能 (Supported Actions)'}")
    print("-" * 75)

    try:
        for model in client.models.list():
            # モデル名（例: models/gemini-2.5-flash など）
            model_name = model.name
            
            # テキスト生成やマルチモーダル等でサポートされているメソッド
            methods = getattr(model, "supported_generation_methods", [])
            methods_str = ", ".join(methods) if methods else "N/A"

            print(f"{model_name:<35} | {methods_str}")
            
    except Exception as e:
        print(f"モデル一覧の取得中にエラーが発生しました: {e}")

if __name__ == "__main__":
    main()