local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local snippets = {
  s(
    "@med",
    t({
      "@media (min-width: 360px) {",
      "}",
      "",
      "@media (min-width: 414px) {",
      "}",
      "",
      "@media (min-width: 576px) {",
      "}",
      "",
      "@media (min-width: 768px) {",
      "}",
      "",
      "@media (min-width: 992px) {",
      "}",
      "",
      "@media (min-width: 1200px) {",
      "}",
      "",
      "@media (min-width: 1366px) {",
      "}",
      "",
      "@media (min-width: 1440px) {",
      "}",
      "",
      "@media (min-width: 1680px) {",
      "}",
      "",
      "@media (min-width: 1920px) {",
      "}",
    })
  ),
}

return snippets
