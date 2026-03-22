vim.keymap.set("n", "<F5>", function()
  if vim.bo.buftype == "" then
    vim.cmd("w")
  end

  local root = vim.fn.getcwd()
  local file = vim.fn.expand("%:p")
  local ft = vim.bo.filetype
  local cmd = ""

  -- Cấu hình lệnh chạy cho từng ngôn ngữ
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
    -- Lấy tên file không có đuôi để làm tên file thực thi (ví dụ: main.cpp -> main)
    local output_file = vim.fn.expand("%:p:r")
    -- Lệnh: Biên dịch với chuẩn c++17 và chạy nếu biên dịch thành công
    cmd = string.format("g++ -std=c++17 %s -o %s && %s", file, output_file, output_file)
  elseif ft == "java" then
    local path_sep = "/"
    -- 1. Tự động tìm gốc của Source Code (hỗ trợ cả Maven src/main/java và folder thường)
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

    -- 2. Chuyển đổi đường dẫn file thành Fully Qualified Class Name
    local class_name = ""
    if start_idx then
      -- Lấy phần sau src/main/java/
      local relative_path = file:sub(start_idx + #file:match(".*" .. path_sep .. "java" .. path_sep) or start_idx + 4)
      -- Cách an toàn hơn: tìm từ khóa 'package' ngay trong nội dung file
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
  -- Sử dụng Snacks Terminal
  require("snacks").terminal.open(cmd, {
    win = {
      position = "bottom", -- Mở ở dưới
      height = 0.4, -- Chiếm 40% màn hình
    },
    -- Đặt tên để Snacks quản lý (giúp không mở nhiều window)
    name = "RUN_LOG_" .. ft:upper(),
  })

  -- Gọi hàm từ module tiện ích
  -- term_util.run_in_terminal(cmd, "RUN_LOG_" .. ft:upper())
end, { desc = "Universal Run (F5)" })
vim.keymap.set("n", "<Tab>", "i", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Xóa không lưu vào register" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Xóa đến cuối dòng không lưu" })
