# 第3回 解答

## 演習

- 第1回（素のLLM）とエージェントの回答の違い：
    - 素のエージェントではそれっぽい質問だったが、make_quize をツール登録したところ、意図した形式となった。
    ```shell
    @naga23ken ➜ /workspaces/lecture-ai-engineering-2026 (lec03) $  uv run python -m app.agent --trace "第2回の 内容から確認問題を1問出して"
    [model] gemini-3.5-flash-lite
    第2回（ファインチューニングとLoRA）の内容から、理解度を確認するための問題を出しますね。

    ---

    **【確認問題】**

    ファインチューニング（特にSFT）を行う際、「出力形式や口調、特定のタスクの振る舞いを身につけさせる」目的には非常に適していますが、「新しく発生した事実や頻繁に変わる情報」を学習させる手段としてはあまり向かないとされています。

    その理由として最も適切なものを、次の①〜③の中から1つ選んでください。

    ① 事前学習を行っていないモデルではファインチューニングが技術的に不可能なため。
    ② 新しい情報や頻繁に変わる情報は、モデルの重みを更新するよりも外部データやツールで参照させる方が管理や更新の面で効率的で確実なため。
    ③ ファインチューニングを行うとモデルのファイルサイズが小さくなりすぎて新しい情報を保持できなくなるため。

    ---

    考えてみてくださいね！回答やヒントが欲しいときはいつでも声をかけてください。

    第2回

    --- trace ---
    [tool call]   get_lecture_summary({'lecture': 2})
    [tool return] get_lecture_summary -> # 第2回 ファインチューニングとLoRA

    ## この回のねらい

    - 事前学習とファインチューニングの違い、ファインチューニングが向く場面と向かない場面を理解する
    - LoRAの考え方を理解し、Google Colab上で小さなモデルを…
    [usage] RunUsage(cost=Decimal('0.0009515'), details={'text_prompt_tokens': 1180}, input_text_tokens=1180, input_tokens=1180, output_tokens=239, requests=2, tool_calls=1)
    @naga23ken ➜ /workspaces/lecture-ai-engineering-2026 (lec03) $ # make_quizを登録
    @naga23ken ➜ /workspaces/lecture-ai-engineering-2026 (lec03) $  uv run python -m app.agent --trace "第2回の 内容から確認問題を1問出して"
    [model] gemini-3.5-flash-lite
    第2回から確認問題を1問出題します！

    **Q. 「ランク（LoRAのr）」の意味は？**

    ---
    （※答えを知りたいときや、自分の答えが合っているか確認したいときは、いつでも聞いてくださいね！）

    関連する回：第2回

    --- trace ---
    [tool call]   make_quiz({'lecture': 2})
    [tool return] make_quiz -> {"question": "「ランク（LoRAのr）」の意味は？", "answer": "LoRAで使う低ランク行列の大きさを決めるハイパーパラメータ。大きいほど表現力が上がるが、学習するパラメータとメモリも増える。"}…
    [usage] RunUsage(cost=Decimal('0.0004666'), details={'text_prompt_tokens': 922}, input_text_tokens=922, input_tokens=922, output_tokens=76, requests=2, tool_calls=1)
    ```

- `--trace` で見えたツール呼び出し（ツール名と引数）： 下記の通り想定通りです。
    ```
    [make_quiz]
    指定した回の用語から確認問題を1問作り、問題と答えを返す。
    
    講義内容の理解を確認したいときに使う。
    
    用語の中からランダムに選択して問題と解答を返す。
    問題は、『「用語」の意味は？』の形式とする。
    回答はJSON形式とする。
    引数: {"lecture": {"type": "integer"}}
    ```
- 1つの質問での LLM 呼び出し回数（`requests`）： 2 回
- 追加したツールと、docstring に書いた説明： 下記ソースより抜粋
    ```python
    def make_quiz(lecture: int) -> str:
    """指定した回の用語から確認問題を1問作り、問題と答えを返す。

    講義内容の理解を確認したいときに使う。

    用語の中からランダムに選択して問題と解答を返す。
    問題は、『「用語」の意味は？』の形式とする。
    回答はJSON形式とする。
    """
    ```


## 宿題

- 取り組んだレベル：実装
- やったこと：
    1. Geminiを壁打ちに、実装の戦略立案。DeferredToolResponsesについても調査。この場合、AI側ではなくハーネス側でユーザー確認を実装となることを理解。
    2. tools.py の実装
        - def save_learning_log(question: str, answer: str)
    3. agent.py に実装
        - INSTRUCTIONSに学習ログの保管指示を追加
        - save_learning_log を requires_approval=True で tool登録
        - agent のインスタンス作成時に、DeferredToolResponses の設定追加
        - main に、承認依頼時の動作を
- 結果：
    - 下記の通り、ユーザー確認の結果を受けて学習保管されることが確認できた。logファイルも確認済み。
        ```shell
        @naga23ken ➜ /workspaces/lecture-ai-engineering-2026 (lec03) $ uv run python -m app.agent "LoRAについて教え て。"
        [model] gemini-3.5-flash-lite
        -- 承認が必要です。承認待ち件数:1 件 --

        承認対象: save_learning_log
        目的: 質問と回答を学習ログ（log/learning_log.json）に保存します。

        この内容の実行を承認しますか？ (1：はい、2：いいえ)
        入力 > 1
        -- 承認されました。--
        LoRA（Low-Rank Adaptation）は、大規模言語モデルなどの事前学習済みモデルを効率的にファインチューニングする手法（PEFT手法）の一つです。

        主な特徴は以下の通りです：
        - **重みを固定して効率化**: 事前学習済みの重みはそのまま固定し、重みの更新分のみを「2つの小さな行列の積（低ランク行列）」で近似して学習します。
        - **学習コストの削減**: 学習すべきパラメータが非常に少なくなるため、メモリ消費を抑えながら効率よく学習できます。
        - **軽量な保存**: 学習結果（アダプタ）を非常に小さなファイルサイズで保存・共有できます。

        （関連する回: 第2回）
        ```
    
- 気づき・疑問：
    - INSTRUCTIONの書き方によって、なかなか保存してくれなかった。「後学のため保管する」などでは適切に保管されず、「やり取りをが絶対保管する」でも保管されず、「やり取りを学習ログとして必ず保存する」と記載してやっとログが保管されるようになった。
    - 調査の過程で、ユーザーの確認を1. LLMに実施させる、2. tool側で実施する、3. ハーネス側で実施する、の３つのパターンがあることがわかった。
    - 実装の自由度の高さはわかったが、AIのコントロール（プロンプト）が難しいことは、改めて感じた。このINSTRUCTIONでもたまに保管しないことがあった。
    - 演習で実施した確認問題だと保管しない。やり取りと判断されないのか？疑問である。
        ```shell
        @naga23ken ➜ /workspaces/lecture-ai-engineering-2026 (lec03) $  uv run python -m app.agent "第2回の内容から 
        確認問題を1問出して"
        [model] gemini-3.5-flash-lite
        -- 承認要求はありませんでした。--
        第2回の内容から確認問題を出します！

        **問題：** 「ファインチューニング」の意味は？

        ぜひ考えてみてくださいね。答えが分かったら教えてください！

        （関連する回：第2回）
        ```


以上
