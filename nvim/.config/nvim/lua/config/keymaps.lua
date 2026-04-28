-- vim.keymap.set("n", "<leader>e", function()
--   Snacks.explorer({ cwd = vim.fn.getcwd() })
-- end, { desc = "Explorer Snacks (cwd)" })
--
vim.keymap.set("n", "<Tab>", "i", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "x", [["_d]], { noremap = true })
vim.keymap.set("n", "xx", [["_dd]], { noremap = true })
vim.keymap.set("n", "U", "g+", { desc = "Redo (time travel forward)" })
vim.keymap.set({ "n", "x" }, "c", '"_c')
vim.keymap.set("n", "C", '"_C')
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>le", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
vim.keymap.set("n", "<F5>", function()
  if vim.bo.buftype == "" then
    vim.cmd("w")
  end

  local root = vim.fn.getcwd()
  local file = vim.fn.expand("%:p")
  local ft = vim.bo.filetype
  local cmd = ""

  if ft == "python" then
    local venv = root .. "/venv/bin/activate"
    local has_venv = vim.fn.filereadable(venv) == 1

    cmd = string.format("export PYTHONPATH=%s && export PYTHONUNBUFFERED=1", root)
    if has_venv then
      cmd = string.format("source venv/bin/activate && %s && python %s", cmd, file)
    else
      cmd = string.format("%s && python %s", cmd, file)
    end
  elseif ft == "cpp" then
    local output_file = vim.fn.expand("%:p:r")
    cmd = string.format("g++ -std=c++17 %s -o %s && %s", file, output_file, output_file)
  elseif ft == "java" then
    local path_sep = "/"
    local source_root = ""
    local patterns = { "src" .. path_sep .. "main" .. path_sep .. "java" .. path_sep, "src" .. path_sep }

    local start_idx = nil
    for _, p in ipairs(patterns) do
      start_idx = file:find(p)
      if start_idx then
        source_root = file:sub(1, start_idx + #p - 1)
        break
      end
    end

    local class_name = ""
    if start_idx then
      local relative_path = file:sub(start_idx + #file:match(".*" .. path_sep .. "java" .. path_sep) or start_idx + 4)
      local first_line = vim.fn.getline(1, 10) -- Đọc 10 dòng đầu
      local package_name = ""
      for _, line in ipairs(first_line) do
        local match = line:match("^package%s+([^;]+);")
        if match then
          package_name = match .. "."
          break
        end
      end
      class_name = package_name .. vim.fn.expand("%:t:r")
    else
      class_name = vim.fn.expand("%:t:r")
    end

    -- 3. Kiểm tra Maven
    local has_pom = vim.fn.filereadable(root .. "/pom.xml") == 1

    if has_pom then
      -- Nếu là Maven, dùng lệnh compile của Maven
      cmd = string.format('cd %s && mvn compile exec:java -Dexec.mainClass="%s"', root, class_name)
    else
      -- Nếu không phải Maven, tự tạo folder bin và biên dịch toàn bộ package hiện tại
      local bin_dir = root .. "/bin"
      if vim.fn.isdirectory(bin_dir) == 0 then
        vim.fn.mkdir(bin_dir, "p")
      end

      -- Tìm thư mục chứa file hiện tại để biên dịch cả package (tránh lỗi symbol)
      local current_dir = vim.fn.expand("%:p:h")
      cmd = string.format(
        "javac -d %s -cp %s %s/*.java && java -cp %s:%s %s",
        bin_dir,
        source_root,
        current_dir,
        bin_dir,
        source_root,
        class_name
      )
    end
  elseif ft == "sh" then
    cmd = string.format("bash %s", file)
  else
    print("F5 chưa hỗ trợ ngôn ngữ: " .. ft)
    return
  end
  cmd = cmd .. "; echo ''; read -p '--- [FINISHED] Press Enter to close ---' temp_var"
  require("snacks").terminal.open(cmd, {
    win = {
      position = "bottom",
      height = 0.3,
    },
    name = "RUN_LOG_" .. ft:upper(),
  })
end, { desc = "Universal Run (F5)" })

vim.keymap.set("n", "<C-/>", function()
  require("snacks").terminal.toggle(nil, {
    win = {
      position = "bottom",
      height = 0.2,
    },
  })
end, { desc = "Terminal" })
vim.keymap.set("n", "<leader>si", function()
  local fzf = require("fzf-lua")
  local path = require("fzf-lua.path")

  fzf.files({
    prompt = "SQL Schemas> ",
    cwd = vim.fn.expand("~"),
    -- Bỏ --absolute-path, fd sẽ trả về đường dẫn tương đối so với cwd
    cmd = "fd -e sql --exclude .git --exclude node_modules --exclude .vscode --exclude .local --exclude .cache",
    actions = {
      ["default"] = function(selected, opts)
        if not selected or #selected == 0 then
          return
        end

        local entry = path.entry_to_file(selected[1], opts)
        local file_path = entry.path

        local ok, content = pcall(vim.fn.readfile, file_path)
        if ok then
          local text = table.concat(content, "\n")

          vim.fn.system("wl-copy", text)

          local filename = vim.fn.fnamemodify(file_path, ":t")
          vim.notify("Copied: " .. filename, vim.log.levels.INFO)
        else
          -- Nếu vẫn lỗi, thông báo này sẽ cho ta thấy chính xác path bị sai chỗ nào
          vim.notify("File not readable: " .. file_path, vim.log.levels.ERROR)
        end
      end,
    },
  })
end, { desc = "Import Schema" })

vim.keymap.set("n", "<leader>se", function()
  -- Hàm helper để xâu chuỗi các input
  local function prompt_export()
    vim.ui.input({ prompt = "Host: ", default = "localhost" }, function(host)
      if not host or host == "" then
        return
      end

      vim.ui.input({ prompt = "Port: ", default = "3306" }, function(port)
        if not port or port == "" then
          return
        end

        vim.ui.input({ prompt = "User: ", default = "admin" }, function(user)
          if not user or user == "" then
            return
          end

          -- Dùng input thường cho password (hoặc vim.fn.inputsecret nếu muốn ẩn)
          vim.ui.input({ prompt = "Password: ", default = "admin" }, function(pass)
            vim.ui.input({ prompt = "Database: " }, function(db_name)
              if not db_name or db_name == "" then
                return
              end

              vim.ui.input({ prompt = "File export name: ", default = db_name .. "_backup.sql" }, function(filename)
                if not filename or filename == "" then
                  return
                end

                -- Tạo câu lệnh dump
                -- Lưu ý: -p và password dính liền nhau, không có khoảng trắng
                local cmd = string.format(
                  "mariadb-dump -h %s -P %s -u %s -p'%s' %s --single-transaction --quick > %s",
                  host,
                  port,
                  user,
                  pass,
                  db_name,
                  filename
                )

                print("\nExporting schema...")
                local result = vim.fn.system(cmd)

                if vim.v.shell_error ~= 0 then
                  vim.notify("Error: " .. result, vim.log.levels.ERROR)
                else
                  vim.notify("Exported successfully: " .. filename, vim.log.levels.INFO)
                end
              end)
            end)
          end)
        end)
      end)
    end)
  end

  prompt_export()
end, { desc = "Export Schema" })
