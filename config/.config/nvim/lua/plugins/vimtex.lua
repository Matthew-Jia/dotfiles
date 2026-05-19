return {
    "lervag/vimtex",
    init = function()
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = { aux_dir = 'aux_build', out_dir = 'build' }
        vim.opt.conceallevel = 0
        vim.g.vimtex_syntax_conceal = {
            additions = 1,
            environments = 1,
            footnotes = 1,
            greek = 1,
            math_bounds = 1,
            math_delimiters = 1,
            math_fracs = 1,
            math_symbols = 1,
            sections = 1,
            styles = 1,
        }
    end,
}