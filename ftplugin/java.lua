local keymap = vim.keymap
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local opts = { noremap = true, silent = true }
local on_attach = function(_, bufnr)
    opts.buffer = bufnr

    -- set keybinds
    opts.desc = "Show LSP references"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

    opts.desc = "Show LSP definitions"
    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local home = vim.env.HOME;
local root_markers = {'.git', '.classpath', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle'}
-- Use lspconfig's utility for root detection here
local root_dir = require('jdtls.setup').find_root(root_markers);
if not root_dir then
    print("JDTLS Warning: Could not find project root for current file. Using CWD.")
    root_dir = vim.fn.getcwd()
end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace/' .. project_name
vim.fn.mkdir(workspace_dir, 'p')

local system_os = ""
-- Determine OS
if vim.fn.has("mac") == 1 then
    system_os = "mac"
elseif vim.fn.has("unix") == 1 then
    system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    system_os = "win"
else
    print("OS not found, defaulting to 'linux'")
    system_os = "linux"
end

local mason_registry = require('mason-registry')
local jdtls_pkg = mason_registry.get_package('jdtls')
if not jdtls_pkg:is_installed() then
    print("JDTLS Error: jdtls package not found via Mason. Skipping setup.")
    return;
end
local jdtls_path = jdtls_pkg:get_install_path()

local jdtls_launcher_jars = vim.split(vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'), '\n')
if #jdtls_launcher_jars == 0 then
    print("JDTLS Error: Could not find JDTLS Equinox launcher JAR. Skipping setup.")
    return;
end
local jdtls_launcher_jar = jdtls_launcher_jars[1]
local jdtls_config_dir = jdtls_path .. "/config_" .. system_os;

local lombok_path = vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar";
if not lombok_path then
    print("JDTLS Warning: Could not find lombok.jar in standard Mason locations. Lombok support might be missing.")
end

local config = {
    cmd = {

        -- 💀
        home .. '/.sdkman/candidates/java/21.0.6-tem/bin/java',
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. vim.fn.fnameescape(lombok_path),
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        -- 💀
        '-jar', vim.fn.fnameescape(jdtls_launcher_jar),
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version


        -- 💀
        '-configuration', vim.fn.fnameescape(jdtls_config_dir),
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.


        -- 💀
        -- See `data directory configuration` section in the README
        '-data', vim.fn.fnameescape(workspace_dir),
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    --
    -- vim.fs.root requires Neovim 0.10.
    -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
    root_dir = root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            home = home .. "/.sdkman/candidates/java/21.0.6-tem/",
            configuration = {
                downloadSources = true,
                updateBuildConfiguration = "interactive",
            },
            runtimes = {
                {
                    name = "JavaSE-1.8",
                    path = home .. "/.sdkman/candidates/java/8.0.442-tem/",
                },
                {
                    name = "JavaSE-11",
                    path = home .. "/.sdkman/candidates/java/11.0.26-tem/",
                },
                {
                    name = "JavaSE-17",
                    path = home .. "/.sdkman/candidates/java/17.0.15-tem/",
                },
                {
                    name = "JavaSE-21",
                    path = home .. "/.sdkman/candidates/java/21.0.6-tem/",
                },
            },
            maven = {
                downloadSources = true,
            },
            gradle = {
                enabled = true,
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            signatureHelp = { enabled = true },
            completion = {
                importOrder = {
                    "java",
                    "javax",
                    "com",
                    "org",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            -- Ensure build system import is enabled (often default, but explicit)
            import = {
                gradle = { enabled = true },
                maven = { enabled = true },
            },
            -- Add other settings if needed
            -- format = { enabled = true },
        }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = {}
    },

    on_attach = on_attach,
    capabilities = capabilities,
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
