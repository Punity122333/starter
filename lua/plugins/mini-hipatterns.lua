

return {
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPre",
    opts = function()
      local hi = require("mini.hipatterns")

      local function hsl_to_hex(h, s, l)
        local function q(p, q, t)
          if t < 0 then t = t + 1 end
          if t > 1 then t = t - 1 end
          if t < 1 / 6 then return p + (q - p) * 6 * t end
          if t < 1 / 2 then return q end
          if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
          return p
        end
        h, s, l = h / 360, s / 100, l / 100
        local r, g, b
        if s == 0 then r, g, b = l, l, l
        else
          local _q = l < 0.5 and l * (1 + s) or l + s - l * s
          local _p = 2 * l - _q
          r, g, b = q(_p, _q, h + 1 / 3), q(_p, _q, h), q(_p, _q, h - 1 / 3)
        end
        return string.format("#%02x%02x%02x", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
      end

      local function oklch_to_hex(l, c, h)
        l, c, h = l / 100, (c or 0), (h or 0) * (math.pi / 180)
        local a, b = c * math.cos(h), c * math.sin(h)
        local l_ = l + 0.3963 * a + 0.2158 * b
        local m_ = l - 0.1055 * a - 0.0638 * b
        local s_ = l - 0.0894 * a - 1.2914 * b
        local r = l_ ^ 3 * 4.0767 - m_ ^ 3 * 3.3077 + s_ ^ 3 * 0.2309
        local g = l_ ^ 3 * -1.2684 + m_ ^ 3 * 2.6097 - s_ ^ 3 * -0.3413
        local b_ = l_ ^ 3 * -0.0041 + m_ ^ 3 * -0.7034 + s_ ^ 3 * 1.7076
        local function f(x)
          x = x > 0.0031308 and (1.055 * x ^ (1 / 2.4) - 0.055) or 12.92 * x
          return math.max(0, math.min(255, math.floor(x * 255 + 0.5)))
        end
        return string.format("#%02x%02x%02x", f(r), f(g), f(b_))
      end

      return {
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),

          short_hex_color = {
            pattern = "#%x%x%x%f[%X]",
            group = function(_, _, data)
              if not data.captures then return nil end
              local r, g, b = data.full_match:sub(2, 2), data.full_match:sub(3, 3), data.full_match:sub(4, 4)
              return hi.compute_hex_color_group(string.format("#%s%s%s%s%s%s", r, r, g, g, b, b), "bg")
            end,
          },

          rgba_color = {
            pattern = "rgba?%((%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*[%/,]?%s*[%d%.%%]*%)",
            group = function(_, _, data)
              if not data.captures then return nil end
              local r, g, b = tonumber(data.captures[1]), tonumber(data.captures[2]), tonumber(data.captures[3])
              if not r or r > 255 or not g or g > 255 or not b or b > 255 then return nil end
              return hi.compute_hex_color_group(string.format("#%02x%02x%02x", r, g, b), "bg")
            end,
          },

          hsl_color = {
            pattern = "hsla?%((%d+)%s*,?%s*(%d+)%%?%s*,?%s*(%d+)%%?%s*[%/,]?%s*[%d%.%%]*%)",
            group = function(_, _, data)
              if not data.captures then return nil end
              local h, s, l = tonumber(data.captures[1]), tonumber(data.captures[2]), tonumber(data.captures[3])
              if not h or not s or not l then return nil end
              return hi.compute_hex_color_group(hsl_to_hex(h, s, l), "bg")
            end,
          },

          oklch_color = {
            pattern = "oklch%(([%d%.]+)%%?%s+([%d%.]+)%s+([%d%.]+)%s*[%/]?%s*[%d%.%%]*%)",
            group = function(_, _, data)
              if not data.captures then return nil end
              local l, c, h = tonumber(data.captures[1]), tonumber(data.captures[2]), tonumber(data.captures[3])
              if not l or not c or not h then return nil end
              return hi.compute_hex_color_group(oklch_to_hex(l, c, h), "bg")
            end,
          },

          tailwind_hex = {
            pattern = "%%[%%#(%x%x%x%x%x%x)%%]",
            group = function(_, _, data)
              if not data.captures then return nil end
              return hi.compute_hex_color_group("#" .. data.captures[1], "bg")
            end,
          },
        },
      }
    end,
  },
}

