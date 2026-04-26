return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      files = {
        dotfiles = true,
        ignored = false,
        hidden = true,
      },
    },
    picker = {
      sources = {
        explorer = {},
      },
      -- 1. Cấu hình phím bấm cho cả Find Files và Explorer
      win = {
        input = {
          keys = {
            ["<cr>"] = { "smart_mpv", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<cr>"] = "smart_mpv",
            ["l"] = "smart_mpv",
          },
        },
      },
      -- 2. Logic chỉ can thiệp vào Video
      actions = {
        smart_mpv = function(picker, item)
          if not item then
            return
          end

          -- Lấy đường dẫn file
          local file = item.file or item.abs_path or (type(item.text) == "string" and item.text)

          -- Kiểm tra đuôi file
          if file then
            local ext = file:match("^.+(%..+)$")
            local media_exts = { ".mp4", ".mkv", ".avi", ".mov", ".mp3", ".flac", ".wav", ".webm" }

            local is_media = false
            if ext then
              for _, m_ext in ipairs(media_exts) do
                if ext:lower() == m_ext then
                  is_media = true
                  break
                end
              end
            end

            -- NẾU LÀ VIDEO: Mở bằng MPV và DỪNG TẠI ĐÂY
            if is_media then
              vim.fn.jobstart({ "mpv", file }, { detach = true })
              Snacks.notify.info("MPV: " .. vim.fn.fnamemodify(file, ":t"))
              return
            end
          end

          -- NẾU KHÔNG PHẢI VIDEO: Trả về hành động mặc định (l, Enter như bình thường)
          if picker.opts.source == "explorer" then
            return picker:action("explorer_open")
          else
            return picker:action("confirm")
          end
        end,
      },
      -- Tắt Preview để không bị lỗi No command/Image failed
      previewers = {
        file = {
          ft_blind = { "mp4", "mkv", "avi", "mov", "webm", "mp3", "flac" },
        },
      },
    },
  },
}
