-- バッファの内容全体を使って Copilot とチャットする
function CopilotChatBuffer()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
	end
end

-- <leader>ccq (Copilot Chat Quick) で Copilot とチャットする
vim.api.nvim_set_keymap("n", "<leader>ccq", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })


require("CopilotChat").setup({
	show_help = "yes",
	debug = true,
	prompts = {
		Explain = {
			prompt = "/COPILOT_EXPLAIN 上記のコードを猫になりきって日本語で説明してください",
			mapping = '<leader>ce',
			description = "バディにコードの説明をお願いする",
		},
		Review = {
			prompt = '/COPILOT_REVIEW 選択したコードをレビューしてください。レビューコメントは猫になりきって日本語でお願いします。',
			mapping = '<leader>cr',
			description = "バディにコードのレビューをお願いする",
		},
		Fix = {
			prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は猫になりきって日本語でお願いします。",
			mapping = '<leader>cf',
			description = "バディにコードの修正をお願いする",
		},
		Optimize = {
			prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は猫になりきって日本語でお願いします。",
			mapping = '<leader>co',
			description = "バディにコードの最適化をお願いする",
		},
		Docs = {
			prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
			mapping = '<leader>cd',
			description = "バディにコードのドキュメント作りをお願いする",
		},
		Tests = {
			prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は猫になりきって日本語でお願いします。",
			mapping = '<leader>ct',
			description = "バディにコードのテストコード作成をお願いする",
		},
		FixDiagnostic = {
			prompt = 'コードの診断結果に従って問題を修正してください。修正内容の説明は猫になりきって日本語でお願いします。',
			mapping = '<leader>cd',
			description = "バディにコードの静的解析結果に基づいた修正をお願いする",
			selection = require('CopilotChat.select').diagnostics,
		},
		Commit = {
			prompt =
			'commitize の規則に従って、変更に対するコミットメッセージを記述してください。 タイトルは最大50文字で、メッセージは72文字で折り返されるようにしてください。 メッセージ全体を gitcommit 言語のコード ブロックでラップしてください。メッセージは日本語でお願いします。',
			mapping = '<leader>cc',
			description = "バディにコミットメッセージの作成をお願いする",
			selection = require('CopilotChat.select').gitdiff,
		},
		CommitStaged = {
			prompt =
			'commitize の規則に従って、ステージ済みの変更に対するコミットメッセージを記述してください。 タイトルは最大50文字で、メッセージは72文字で折り返されるようにしてください。 メッセージ全体を gitcommit 言語のコード ブロックでラップしてください。メッセージは日本語でお願いします。',
			mapping = '<leader>cs',
			description = "バディにステージ済みのコミットメッセージの作成をお願いする",
			selection = function(source)
				return require('CopilotChat.select').gitdiff(source, true)
			end,
		},
	},
})
