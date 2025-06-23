return {
	"norcalli/nvim-colorizer.lua",
	enabled = true,
	config = function()
		require("colorizer").setup({
			"*",
			css = { rgb_fn = true },
		})
	end,
}
