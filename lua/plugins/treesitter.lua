-- 1. Registro nativo del tipo de archivo (.blade.php -> blade)
vim.filetype.add({
	pattern = {
		['.*%.blade%.php'] = 'blade',
	},
})

-- 2. Activar el resaltado nativo de Tree-sitter al abrir estos archivos
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "php", "html", "blade" },
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- 3. Compilación e instalación manual del parser de Blade
-- Creamos una función que clona y compila el parser usando la herramienta del sistema
local function compile_blade_parser()
	local parser_dir = vim.fn.stdpath("data") .. "/tree-sitter-parsers"
	local blade_dir = parser_dir .. "/tree-sitter-blade"
	local output_dir = vim.fn.stdpath("config") .. "/parsers"

	-- Crear los directorios si no existen
	vim.fn.mkdir(parser_dir, "p")
	vim.fn.mkdir(output_dir, "p")

	if vim.fn.empty(vim.fn.glob(blade_dir)) > 0 then
		vim.notify("Descargando parser de Blade...", vim.log.levels.INFO)
		vim.fn.system({ "git", "clone", "https://github.com/EmranMR/tree-sitter-blade", blade_dir })
	end

	vim.notify("Compilando parser de Blade nativamente...", vim.log.levels.INFO)
	
	-- Compilamos usando el CLI de tree-sitter que instalaste con Homebrew
	vim.fn.system({
		"tree-sitter", "build",
		"-o", output_dir .. "/blade.so",
		blade_dir
	})

	vim.notify("¡Parser de Blade instalado con éxito!", vim.log.levels.INFO)
end

-- Creamos un comando personalizado en Neovim para lanzar la instalación
vim.api.nvim_create_user_command("InstallBladeParser", compile_blade_parser, {})

-- 4. Indicarle a Neovim 0.12 dónde buscar los parsers manuales
vim.opt.runtimepath:append(vim.fn.stdpath("config"))
