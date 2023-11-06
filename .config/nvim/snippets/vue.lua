local ls = require("luasnip")
local t = ls.text_node

return {
  ls.s({
    trig = "coV",
    name = "componentVue",
  }, {
    t({
      "<script setup>",
      "</script>",
      "",
      "<template>",
      "</template>",
      "",
      '<style lang="scss" scoped>',
      "</style>",
    }),
  }),
}
