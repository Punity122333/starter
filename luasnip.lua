return {
	"L3MON4D3/LuaSnip",
	lazy = false,
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		history = true,
		updateevents = "TextChanged,TextChangedI",
	},
	config = function(_, opts)
		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		local f = ls.function_node
		local fmt = require("luasnip.extras.fmt").fmt
		local rep = require("luasnip.extras").rep

		ls.config.set_config(opts)
		require("luasnip.loaders.from_vscode").lazy_load()

		local function date()
			return { os.date("%Y-%m-%d") }
		end

		-- ─────────────────────────────────────────────────────────────────────────
		-- C++
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("cpp", {
			s("cppbase", {
				t({ "#include <iostream>", "using namespace std;", "", "int main() {", "\t" }),
				i(1, "// logic"),
				t({ "", "\treturn 0;", "}" }),
			}),
			s("fio", t({ "ios_base::sync_with_stdio(false);", "cin.tie(NULL);" })),
			s(
				"cls",
				fmt(
					[[
          class {} {{
          public:
              {}() = default;
              ~{}() = default;

          private:
              {}
          }};]],
					{ i(1, "MyClass"), rep(1), rep(1), i(2) }
				)
			),
			s("struct", fmt("struct {} {{\n    {}\n}};", { i(1, "MyStruct"), i(2) })),
			s("enum", fmt("enum class {} {{\n    {}\n}};", { i(1, "MyEnum"), i(2, "Value") })),
			s(
				"tpl",
				fmt(
					"template <typename {}>\n{} {}({}) {{\n    {}\n}}",
					{ i(1, "T"), i(2, "T"), i(3, "func"), i(4), i(5) }
				)
			),
			s("ns", fmt("namespace {} {{\n\n{}\n\n}} // namespace {}", { i(1, "ns"), i(2), rep(1) })),
			s("guard", fmt("#ifndef {1}_H\n#define {1}_H\n\n{2}\n\n#endif // {1}_H", { i(1, "HEADER"), i(2) })),
			s("vec", fmt("std::vector<{}> {} = {{{}}};", { i(1, "int"), i(2, "v"), i(3) })),
			s("map", fmt("std::unordered_map<{}, {}> {};", { i(1, "std::string"), i(2, "int"), i(3, "m") })),
			s("set", fmt("std::unordered_set<{}> {};", { i(1, "int"), i(2, "s") })),
			s("pq", fmt("std::priority_queue<{}> {};", { i(1, "int"), i(2, "pq") })),
			s(
				"pair",
				fmt("std::pair<{}, {}> {} = {{{}, {}}};", { i(1, "int"), i(2, "int"), i(3, "p"), i(4, "0"), i(5, "0") })
			),
			s(
				"fori",
				fmt("for (int {} = 0; {} < {}; {}++) {{\n    {}\n}}", { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3) })
			),
			s("forvec", fmt("for (auto& {} : {}) {{\n    {}\n}}", { i(1, "x"), i(2, "v"), i(3) })),
			s("lambda", fmt("auto {} = [{}]({}) {{ return {}; }};", { i(1, "fn"), i(2), i(3), i(4) })),
			s("unique", fmt("auto {} = std::make_unique<{}>({});", { i(1, "ptr"), i(2, "T"), i(3) })),
			s("shared", fmt("auto {} = std::make_shared<{}>({});", { i(1, "ptr"), i(2, "T"), i(3) })),
			s("thread", fmt("std::thread {}([&]() {{\n    {}\n}});\n{}.join();", { i(1, "t"), i(2), rep(1) })),
			s(
				"mutex",
				fmt(
					"std::mutex {};\n{{\n    std::lock_guard<std::mutex> lock({});\n    {}\n}}",
					{ i(1, "mtx"), rep(1), i(2) }
				)
			),
			s(
				"try",
				fmt(
					"try {{\n    {}\n}} catch (const std::exception& e) {{\n    std::cerr << e.what() << '\\n';\n}}",
					{ i(1) }
				)
			),
			s("cout", fmt("std::cout << {} << '\\n';", { i(1, '"Hello"') })),
			s("cerr", fmt("std::cerr << {} << '\\n';", { i(1, '"Error"') })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- C
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("c", {
			s("cbase", {
				t({ "#include <stdio.h>", "#include <stdlib.h>", "", "int main(int argc, char *argv[]) {", "\t" }),
				i(1, "// logic"),
				t({ "", "\treturn 0;", "}" }),
			}),
			s("struct", fmt("typedef struct {{\n    {}\n}} {};", { i(1), i(2, "MyStruct") })),
			s(
				"malloc",
				fmt(
					'{} *{} = malloc({} * sizeof({}));\nif (!{}) {{ perror("malloc"); exit(1); }}',
					{ i(1, "int"), i(2, "ptr"), i(3, "n"), rep(1), rep(2) }
				)
			),
			s("fn", fmt("{} {}({}) {{\n    {}\n}}", { i(1, "void"), i(2, "func"), i(3), i(4) })),
			s(
				"fori",
				fmt("for (int {} = 0; {} < {}; {}++) {{\n    {}\n}}", { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3) })
			),
			s("printf", fmt('printf("{}\\n", {});', { i(1, "%s"), i(2) })),
			s("scanf", fmt('scanf("{}", &{});', { i(1, "%d"), i(2, "x") })),
			s(
				"fopen",
				fmt(
					'FILE *{} = fopen("{}", "{}");\nif ({} == NULL) {{ perror("fopen"); return 1; }}',
					{ i(1, "fp"), i(2, "file.txt"), i(3, "r"), rep(1) }
				)
			),
			s("guard", fmt("#ifndef {1}_H\n#define {1}_H\n\n{2}\n\n#endif // {1}_H", { i(1, "HEADER"), i(2) })),
			s("arr", fmt("{} {}[{}] = {{{}}};", { i(1, "int"), i(2, "arr"), i(3, "10"), i(4, "0") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Python
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("python", {
			s("pybase", {
				t({ "#!/usr/bin/env python3", '"""', "" }),
				i(1, "Module docstring"),
				t({ "", '"""', "", "" }),
				t({ "def main():", "\t" }),
				i(2, "pass"),
				t({ "", "", "", 'if __name__ == "__main__":', "\tmain()" }),
			}),
			s(
				"cls",
				fmt(
					'class {}({}):\n    """{}"""\n\n    def __init__(self, {}):\n        {}\n\n    def __repr__(self):\n        return f"{}()"',
					{ i(1, "MyClass"), i(2, "object"), i(3, "Docstring"), i(4), i(5, "pass"), rep(1) }
				)
			),
			s("fn", fmt('def {}({}):\n    """{}"""\n    {}', { i(1, "func"), i(2), i(3, "Docstring"), i(4, "pass") })),
			s(
				"afn",
				fmt('async def {}({}):\n    """{}"""\n    {}', { i(1, "func"), i(2), i(3, "Docstring"), i(4, "pass") })
			),
			s("lc", fmt("[{} for {} in {}{}]", { i(1, "x"), i(2, "x"), i(3, "iterable"), i(4) })),
			s("dc", fmt("{{{}: {} for {}, {} in {}.items()}}", { i(1, "k"), i(2, "v"), rep(1), rep(2), i(3, "d") })),
			s(
				"try",
				fmt("try:\n    {}\nexcept {} as e:\n    {}", { i(1, "pass"), i(2, "Exception"), i(3, "print(e)") })
			),
			s("with", fmt("with {}({}) as {}:\n    {}", { i(1, "open"), i(2, '"file.txt"'), i(3, "f"), i(4, "pass") })),
			s(
				"deco",
				fmt(
					"def {}(func):\n    def wrapper(*args, **kwargs):\n        {}\n        return func(*args, **kwargs)\n    return wrapper",
					{ i(1, "decorator"), i(2, "pass") }
				)
			),
			s(
				"prop",
				fmt(
					"@property\ndef {}(self):\n    return self._{}\n\n@{}.setter\ndef {}(self, value):\n    self._{} = value",
					{ i(1, "name"), rep(1), rep(1), rep(1), rep(1) }
				)
			),
			s(
				"dataclass",
				fmt(
					"from dataclasses import dataclass, field\n\n@dataclass\nclass {}:\n    {}: {}\n    {}: {} = field(default_factory=list)",
					{ i(1, "MyData"), i(2, "name"), i(3, "str"), i(4, "items"), i(5, "list") }
				)
			),
			s(
				"enum",
				fmt("from enum import Enum\n\nclass {}(Enum):\n    {} = {}", { i(1, "Color"), i(2, "RED"), i(3, "1") })
			),
			s(
				"tc",
				fmt(
					'import unittest\n\nclass {}(unittest.TestCase):\n    def test_{}(self):\n        {}\n\nif __name__ == "__main__":\n    unittest.main()',
					{ i(1, "TestModule"), i(2, "something"), i(3, "self.assertEqual(True, True)") }
				)
			),
			s(
				"argparse",
				fmt(
					'import argparse\n\nparser = argparse.ArgumentParser(description="{}")\nparser.add_argument("{}", type={}, help="{}")\nargs = parser.parse_args()',
					{ i(1, "Script"), i(2, "--foo"), i(3, "str"), i(4, "help") }
				)
			),
			s("typing", t("from typing import Any, Dict, List, Optional, Tuple, Union")),
			s("pprint", t("from pprint import pprint")),
			s("pdb", t("import pdb; pdb.set_trace()")),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- JavaScript
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("javascript", {
			s("fn", fmt("const {} = ({}) => {{\n  {}\n}};", { i(1, "func"), i(2), i(3) })),
			s("afn", fmt("const {} = async ({}) => {{\n  {}\n}};", { i(1, "func"), i(2), i(3) })),
			s("cl", fmt("console.log({});", { i(1) })),
			s("ce", fmt("console.error({});", { i(1) })),
			s("cw", fmt("console.warn({});", { i(1) })),
			s("imp", fmt('import {{ {} }} from "{}";', { i(1), i(2) })),
			s("impa", fmt('import {} from "{}";', { i(1), i(2) })),
			s("exp", fmt("export const {} = {};", { i(1), i(2) })),
			s(
				"cls",
				fmt(
					"class {} {{\n  constructor({}) {{\n    {}\n  }}\n\n  {}({}) {{\n    {}\n  }}\n}}",
					{ i(1, "MyClass"), i(2), i(3), i(4, "method"), i(5), i(6) }
				)
			),
			s("prom", fmt("new Promise((resolve, reject) => {{\n  {}\n}});", { i(1) })),
			s("try", fmt("try {{\n  {}\n}} catch (err) {{\n  console.error(err);\n}}", { i(1) })),
			s(
				"fetch",
				fmt(
					'const res = await fetch("{}");\nconst data = await res.json();\n{}',
					{ i(1, "https://api.example.com"), i(2) }
				)
			),
			s("dest", fmt("const {{ {} }} = {};", { i(1), i(2) })),
			s("ternary", fmt("{} ? {} : {}", { i(1, "cond"), i(2, "a"), i(3, "b") })),
			s("foreach", fmt("{}.forEach(({}) => {{\n  {}\n}});", { i(1, "arr"), i(2, "item"), i(3) })),
			s("map", fmt("const {} = {}.map(({}) => {});", { i(1, "result"), i(2, "arr"), i(3, "item"), i(4) })),
			s("filter", fmt("const {} = {}.filter(({}) => {});", { i(1, "result"), i(2, "arr"), i(3, "item"), i(4) })),
			s(
				"reduce",
				fmt(
					"const {} = {}.reduce((acc, {}) => {{\n  {}\n}}, {});",
					{ i(1, "result"), i(2, "arr"), i(3, "item"), i(4, "return acc"), i(5, "[]") }
				)
			),
			s("timeout", fmt("setTimeout(() => {{\n  {}\n}}, {});", { i(1), i(2, "1000") })),
			s("interval", fmt("const {} = setInterval(() => {{\n  {}\n}}, {});", { i(1, "id"), i(2), i(3, "1000") })),
			s(
				"event",
				fmt('{}.addEventListener("{}", ({}) => {{\n  {}\n}});', { i(1, "el"), i(2, "click"), i(3, "e"), i(4) })
			),
			s(
				"sw",
				fmt(
					"switch ({}) {{\n  case {}:\n    {}\n    break;\n  default:\n    {}\n}}",
					{ i(1, "val"), i(2), i(3), i(4) }
				)
			),
			s(
				"jsdoc",
				fmt(
					"/**\n * {}\n * @param {{{}}} {} - {}\n * @returns {{{}}} {}\n */",
					{ i(1, "Description"), i(2, "string"), i(3, "param"), i(4), i(5, "void"), i(6) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- TypeScript
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("typescript", {
			s(
				"fn",
				fmt(
					"const {} = ({}: {}): {} => {{\n  {}\n}};",
					{ i(1, "func"), i(2, "arg"), i(3, "string"), i(4, "void"), i(5) }
				)
			),
			s(
				"afn",
				fmt(
					"const {} = async ({}: {}): Promise<{}> => {{\n  {}\n}};",
					{ i(1, "func"), i(2, "arg"), i(3, "string"), i(4, "void"), i(5) }
				)
			),
			s("iface", fmt("interface {} {{\n  {}: {};\n}}", { i(1, "MyInterface"), i(2, "field"), i(3, "string") })),
			s("type", fmt("type {} = {};", { i(1, "MyType"), i(2, "string | number") })),
			s("enum", fmt('enum {} {{\n  {} = "{}",\n}}', { i(1, "Direction"), i(2, "Up"), i(3, "UP") })),
			s(
				"generic",
				fmt(
					"function {}<{}>({}: {}): {} {{\n  {}\n}}",
					{ i(1, "func"), i(2, "T"), i(3, "arg"), i(4, "T"), i(5, "T"), i(6) }
				)
			),
			s(
				"cls",
				fmt(
					"class {} implements {} {{\n  constructor(private {}: {}) {{}}\n\n  {}(): {} {{\n    {}\n  }}\n}}",
					{
						i(1, "MyClass"),
						i(2, "IMyClass"),
						i(3, "field"),
						i(4, "string"),
						i(5, "method"),
						i(6, "void"),
						i(7),
					}
				)
			),
			s(
				"guard",
				fmt(
					'function {}(val: unknown): val is {} {{\n  return typeof val === "{}";\n}}',
					{ i(1, "isString"), i(2, "string"), i(3, "string") }
				)
			),
			s("record", fmt("Record<{}, {}>", { i(1, "string"), i(2, "unknown") })),
			s("partial", fmt("Partial<{}>", { i(1, "MyType") })),
			s("pick", fmt("Pick<{}, {}>", { i(1, "MyType"), i(2, '"field"') })),
			s("omit", fmt("Omit<{}, {}>", { i(1, "MyType"), i(2, '"field"') })),
			s("nonnull", fmt("NonNullable<{}>", { i(1, "T | null") })),
			s("satisfies", fmt("{} satisfies {}", { i(1, "obj"), i(2, "Type") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Lua
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("lua", {
			s("fn", fmt("local function {}({})\n  {}\nend", { i(1, "func"), i(2), i(3) })),
			s("mfn", fmt("function {}:{}({})\n  {}\nend", { i(1, "MyClass"), i(2, "method"), i(3), i(4) })),
			s(
				"cls",
				fmt(
					"local {} = {{}}\n{}.__index = {}\n\nfunction {}.new({})\n  local self = setmetatable({{}}, {})\n  {}\n  return self\nend\n\nreturn {}",
					{ i(1, "MyClass"), rep(1), rep(1), rep(1), i(2), rep(1), i(3), rep(1) }
				)
			),
			s("if", fmt("if {} then\n  {}\nend", { i(1, "cond"), i(2) })),
			s("ife", fmt("if {} then\n  {}\nelse\n  {}\nend", { i(1, "cond"), i(2), i(3) })),
			s("for", fmt("for {} = {}, {} do\n  {}\nend", { i(1, "i"), i(2, "1"), i(3, "10"), i(4) })),
			s("fori", fmt("for {}, {} in ipairs({}) do\n  {}\nend", { i(1, "i"), i(2, "v"), i(3, "t"), i(4) })),
			s("fork", fmt("for {}, {} in pairs({}) do\n  {}\nend", { i(1, "k"), i(2, "v"), i(3, "t"), i(4) })),
			s("req", fmt('local {} = require("{}")', { i(1), i(2) })),
			s("mod", fmt("local M = {{}}\n\n{}\n\nreturn M", { i(1) })),
			s(
				"pcall",
				fmt(
					"local ok, err = pcall(function()\n  {}\nend)\nif not ok then\n  vim.notify(err, vim.log.levels.ERROR)\nend",
					{ i(1) }
				)
			),
			s(
				"autocmd",
				fmt(
					'vim.api.nvim_create_autocmd("{}", {{\n  pattern = "{}",\n  callback = function({})\n    {}\n  end,\n}})',
					{ i(1, "BufWritePre"), i(2, "*"), i(3, "ev"), i(4) }
				)
			),
			s(
				"map",
				fmt('vim.keymap.set("{}", "{}", {}, {{ desc = "{}" }})', { i(1, "n"), i(2, "<leader>x"), i(3), i(4) })
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Rust
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("rust", {
			s("rsbase", { t({ "fn main() {", "\t" }), i(1, "// logic"), t({ "", "}" }) }),
			s("fn", fmt("fn {}({}) -> {} {{\n    {}\n}}", { i(1, "func"), i(2), i(3, "()"), i(4) })),
			s("afn", fmt("async fn {}({}) -> {} {{\n    {}\n}}", { i(1, "func"), i(2), i(3, "()"), i(4) })),
			s(
				"struct",
				fmt(
					"#[derive(Debug, Clone)]\nstruct {} {{\n    {}: {},\n}}",
					{ i(1, "MyStruct"), i(2, "field"), i(3, "String") }
				)
			),
			s(
				"impl",
				fmt(
					"impl {} {{\n    pub fn new({}) -> Self {{\n        Self {{\n            {}\n        }}\n    }}\n}}",
					{ i(1, "MyStruct"), i(2), i(3) }
				)
			),
			s(
				"enum",
				fmt(
					"#[derive(Debug, Clone)]\nenum {} {{\n    {},\n    {},\n}}",
					{ i(1, "MyEnum"), i(2, "VariantA"), i(3, "VariantB") }
				)
			),
			s(
				"trait",
				fmt("trait {} {{\n    fn {}(&self) -> {};\n}}", { i(1, "MyTrait"), i(2, "method"), i(3, "()") })
			),
			s(
				"match",
				fmt(
					"match {} {{\n    {} => {{\n        {}\n    }},\n    _ => {{}}\n}}",
					{ i(1, "val"), i(2, "pattern"), i(3) }
				)
			),
			s("iflet", fmt("if let {} = {} {{\n    {}\n}}", { i(1, "Some(x)"), i(2, "val"), i(3) })),
			s("whilelet", fmt("while let {} = {} {{\n    {}\n}}", { i(1, "Some(x)"), i(2, "iter.next()"), i(3) })),
			s("res", fmt("Result<{}, {}>", { i(1, "()"), i(2, "Box<dyn std::error::Error>") })),
			s("opt", fmt("Option<{}>", { i(1, "T") })),
			s("vec", fmt("Vec::<{}>::new()", { i(1, "T") })),
			s("hmap", fmt("std::collections::HashMap::<{}, {}>::new()", { i(1, "String"), i(2, "i32") })),
			s("arc", fmt("std::sync::Arc::new({})", { i(1) })),
			s("mutex", fmt("std::sync::Mutex::new({})", { i(1) })),
			s("derive", fmt("#[derive({})]", { i(1, "Debug, Clone, PartialEq") })),
			s(
				"test",
				fmt(
					"#[cfg(test)]\nmod tests {{\n    use super::*;\n\n    #[test]\n    fn test_{}() {{\n        {}\n    }}\n}}",
					{ i(1, "something"), i(2, "assert!(true)") }
				)
			),
			s("clos", fmt("|{}| {{\n    {}\n}}", { i(1), i(2) })),
			s("iter", fmt("{}.iter().map(|{}| {}).collect::<Vec<_>>()", { i(1, "v"), i(2, "x"), i(3, "x") })),
			s("spawn", fmt("std::thread::spawn(|| {{\n    {}\n}});", { i(1) })),
			s("box", fmt("Box::new({})", { i(1) })),
			s("use", fmt("use {}::{{{}}};", { i(1), i(2) })),
			s(
				"main_res",
				fmt("fn main() -> Result<(), Box<dyn std::error::Error>> {{\n    {}\n    Ok(())\n}}", { i(1) })
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Go
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("go", {
			s("gobase", {
				t({ "package main", "", 'import "fmt"', "", "func main() {", "\t" }),
				i(1, "// logic"),
				t({ "", "}" }),
			}),
			s("fn", fmt("func {}({}) {} {{\n    {}\n}}", { i(1, "MyFunc"), i(2), i(3), i(4) })),
			s(
				"mfn",
				fmt(
					"func ({} *{}) {}({}) {} {{\n    {}\n}}",
					{ i(1, "r"), i(2, "MyStruct"), i(3, "Method"), i(4), i(5), i(6) }
				)
			),
			s("struct", fmt("type {} struct {{\n    {} {}\n}}", { i(1, "MyStruct"), i(2, "Field"), i(3, "string") })),
			s(
				"iface",
				fmt("type {} interface {{\n    {}({}) {}\n}}", { i(1, "MyInterface"), i(2, "Method"), i(3), i(4) })
			),
			s("err", fmt("if err != nil {{\n    return {}err\n}}", { i(1) })),
			s("iferr", fmt("{}, err := {}\nif err != nil {{\n    return {}err\n}}", { i(1), i(2), i(3) })),
			s("goroutine", fmt("go func() {{\n    {}\n}}()", { i(1) })),
			s("chan", fmt("make(chan {}, {})", { i(1, "int"), i(2, "1") })),
			s(
				"select",
				fmt("select {{\ncase {} := <-{}:\n    {}\ndefault:\n    {}\n}}", { i(1, "v"), i(2, "ch"), i(3), i(4) })
			),
			s("for", fmt("for {}, {} := range {} {{\n    {}\n}}", { i(1, "i"), i(2, "v"), i(3, "slice"), i(4) })),
			s("map", fmt("map[{}]{}{{}}", { i(1, "string"), i(2, "int") })),
			s(
				"test",
				fmt("func Test{}(t *testing.T) {{\n    {}\n}}", { i(1, "Something"), i(2, "// arrange, act, assert") })
			),
			s(
				"bench",
				fmt(
					"func Benchmark{}(b *testing.B) {{\n    for range b.N {{\n        {}\n    }}\n}}",
					{ i(1, "Something"), i(2) }
				)
			),
			s(
				"http",
				fmt(
					'http.HandleFunc("{}", func(w http.ResponseWriter, r *http.Request) {{\n    {}\n}})\nhttp.ListenAndServe(":{}", nil)',
					{ i(1, "/"), i(2), i(3, "8080") }
				)
			),
			s("init", fmt("func init() {{\n    {}\n}}", { i(1) })),
			s("defer", fmt("defer {}({})", { i(1, "func"), i(2) })),
			s(
				"wg",
				fmt(
					"var {} sync.WaitGroup\n{}.Add({})\ngo func() {{\n    defer {}.Done()\n    {}\n}}()\n{}.Wait()",
					{ i(1, "wg"), rep(1), i(2, "1"), rep(1), i(3), rep(1) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Java
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("java", {
			s(
				"javabase",
				fmt(
					"public class {} {{\n    public static void main(String[] args) {{\n        {}\n    }}\n}}",
					{ i(1, "Main"), i(2) }
				)
			),
			s(
				"cls",
				fmt("public class {} {{\n    public {}() {{\n        {}\n    }}\n}}", { i(1, "MyClass"), rep(1), i(2) })
			),
			s(
				"iface",
				fmt(
					"public interface {} {{\n    {} {}({});\n}}",
					{ i(1, "MyInterface"), i(2, "void"), i(3, "method"), i(4) }
				)
			),
			s("enum", fmt("public enum {} {{\n    {};\n}}", { i(1, "MyEnum"), i(2, "VALUE") })),
			s("record", fmt("public record {}({} {}) {{}}", { i(1, "MyRecord"), i(2, "String"), i(3, "name") })),
			s("fn", fmt("public {} {}({}) {{\n    {}\n}}", { i(1, "void"), i(2, "method"), i(3), i(4) })),
			s("sout", fmt("System.out.println({});", { i(1) })),
			s("serr", fmt("System.err.println({});", { i(1) })),
			s(
				"for",
				fmt("for (int {} = 0; {} < {}; {}++) {{\n    {}\n}}", { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3) })
			),
			s("foreach", fmt("for ({} {} : {}) {{\n    {}\n}}", { i(1, "String"), i(2, "item"), i(3, "list"), i(4) })),
			s(
				"try",
				fmt("try {{\n    {}\n}} catch ({} e) {{\n    e.printStackTrace();\n}}", { i(1), i(2, "Exception") })
			),
			s(
				"stream",
				fmt("{}.stream().filter({} -> {}).collect(Collectors.toList());", { i(1, "list"), i(2, "x"), i(3) })
			),
			s("opt", fmt("Optional.ofNullable({});", { i(1) })),
			s(
				"sw",
				fmt(
					"switch ({}) {{\n    case {}:\n        {}\n        break;\n    default:\n        {}\n}}",
					{ i(1, "val"), i(2), i(3), i(4) }
				)
			),
			s(
				"ann",
				fmt(
					"@{}\npublic {} {}({}) {{\n    {}\n}}",
					{ i(1, "Override"), i(2, "void"), i(3, "method"), i(4), i(5) }
				)
			),
			s("log", fmt("private static final Logger log = LoggerFactory.getLogger({}.class);", { i(1, "MyClass") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Kotlin
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("kotlin", {
			s("ktbase", fmt("fun main() {{\n    {}\n}}", { i(1) })),
			s("fn", fmt("fun {}({}): {} {{\n    {}\n}}", { i(1, "func"), i(2), i(3, "Unit"), i(4) })),
			s(
				"cls",
				fmt("class {}({}: {}) {{\n    {}\n}}", { i(1, "MyClass"), i(2, "val name"), i(3, "String"), i(4) })
			),
			s("data", fmt("data class {}({}: {})", { i(1, "MyData"), i(2, "val name"), i(3, "String") })),
			s("obj", fmt("object {} {{\n    {}\n}}", { i(1, "Singleton"), i(2) })),
			s("ext", fmt("fun {}.{}({}): {} = {}", { i(1, "String"), i(2, "func"), i(3), i(4, "Unit"), i(5) })),
			s("when", fmt("when ({}) {{\n    {} -> {}\n    else -> {}\n}}", { i(1, "val"), i(2), i(3), i(4) })),
			s("let", fmt("{}.let {{ {} -> {} }}", { i(1), i(2, "it"), i(3) })),
			s("apply", fmt("{}.apply {{\n    {}\n}}", { i(1), i(2) })),
			s("also", fmt("{}.also {{ {} -> {} }}", { i(1), i(2, "it"), i(3) })),
			s("scope", fmt("{}.run {{\n    {}\n}}", { i(1), i(2) })),
			s("pln", fmt("println({})", { i(1) })),
			s("list", fmt("listOf({})", { i(1) })),
			s("mlist", fmt("mutableListOf({})", { i(1) })),
			s("map", fmt("mapOf({} to {})", { i(1, '"key"'), i(2, '"value"') })),
			s("co", fmt("CoroutineScope(Dispatchers.IO).launch {{\n    {}\n}}", { i(1) })),
			s("flow", fmt("flow {{\n    emit({})\n}}.collect {{ {} -> {} }}", { i(1), i(2, "value"), i(3) })),
			s(
				"sealed",
				fmt(
					"sealed class {} {{\n    data class {}({}: {}): {}()\n    object {}: {}()\n}}",
					{ i(1, "Result"), i(2, "Success"), i(3, "data"), i(4, "String"), rep(1), i(5, "Failure"), rep(1) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Swift
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("swift", {
			s("swbase", fmt("import Foundation\n\n{}", { i(1) })),
			s(
				"fn",
				fmt(
					"func {}({}: {}) -> {} {{\n    {}\n}}",
					{ i(1, "func"), i(2, "param"), i(3, "String"), i(4, "Void"), i(5) }
				)
			),
			s(
				"cls",
				fmt(
					"class {}: {} {{\n    {}\n    init({}) {{\n        {}\n    }}\n}}",
					{ i(1, "MyClass"), i(2, "AnyObject"), i(3), i(4), i(5) }
				)
			),
			s("struct", fmt("struct {} {{\n    var {}: {}\n}}", { i(1, "MyStruct"), i(2, "field"), i(3, "String") })),
			s("proto", fmt("protocol {} {{\n    func {}()\n}}", { i(1, "MyProtocol"), i(2, "method") })),
			s(
				"enum",
				fmt("enum {} {{\n    case {}\n    case {}\n}}", { i(1, "MyEnum"), i(2, "first"), i(3, "second") })
			),
			s("guard", fmt("guard let {} = {} else {{\n    {}\n}}", { i(1, "val"), i(2), i(3, "return") })),
			s("iflet", fmt("if let {} = {} {{\n    {}\n}}", { i(1, "val"), i(2), i(3) })),
			s("for", fmt("for {} in {} {{\n    {}\n}}", { i(1, "item"), i(2, "items"), i(3) })),
			s("sw", fmt("switch {} {{\ncase {}:\n    {}\ndefault:\n    {}\n}}", { i(1, "val"), i(2), i(3), i(4) })),
			s("ext", fmt("extension {} {{\n    {}\n}}", { i(1, "String"), i(2) })),
			s("clos", fmt("{{ ({}: {}) -> {} in\n    {}\n}}", { i(1, "arg"), i(2, "String"), i(3, "Void"), i(4) })),
			s(
				"async",
				fmt("func {}({}) async throws -> {} {{\n    {}\n}}", { i(1, "func"), i(2), i(3, "Void"), i(4) })
			),
			s("print", fmt('print("{}", {})', { i(1), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Ruby
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("ruby", {
			s("rbbase", { t({ "#!/usr/bin/env ruby", "# frozen_string_literal: true", "", "" }), i(1) }),
			s(
				"cls",
				fmt(
					"class {}\n  def initialize({})\n    {}\n  end\n\n  def {}\n    {}\n  end\nend",
					{ i(1, "MyClass"), i(2), i(3), i(4, "method"), i(5) }
				)
			),
			s("mod", fmt("module {}\n  {}\nend", { i(1, "MyModule"), i(2) })),
			s("fn", fmt("def {}({})\n  {}\nend", { i(1, "method"), i(2), i(3) })),
			s("each", fmt("{}.each do |{}|\n  {}\nend", { i(1, "arr"), i(2, "item"), i(3) })),
			s("map", fmt("{}.map {{ |{}| {} }}", { i(1, "arr"), i(2, "x"), i(3) })),
			s("sel", fmt("{}.select {{ |{}| {} }}", { i(1, "arr"), i(2, "x"), i(3) })),
			s("rej", fmt("{}.reject {{ |{}| {} }}", { i(1, "arr"), i(2, "x"), i(3) })),
			s(
				"begin",
				fmt("begin\n  {}\nrescue {} => e\n  {}\nend", { i(1), i(2, "StandardError"), i(3, "puts e.message") })
			),
			s("attr", fmt("attr_accessor :{}", { i(1, "name") })),
			s(
				"rspec",
				fmt(
					'RSpec.describe {} do\n  describe "#{}" do\n    it "{}" do\n      {}\n    end\n  end\nend',
					{ i(1, "MyClass"), i(2, "method"), i(3, "does something"), i(4) }
				)
			),
			s("pry", t("require 'pry'; binding.pry")),
			s("puts", fmt("puts {}", { i(1) })),
			s("hash", fmt("{{ {}: {} }}", { i(1, "key"), i(2, "value") })),
			s("lambda", fmt("-> ({}) {{ {} }}", { i(1, "x"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- PHP
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("php", {
			s("phpbase", { t({ "<?php", "", "declare(strict_types=1);", "", "" }), i(1) }),
			s(
				"cls",
				fmt(
					"class {} extends {} implements {} {{\n    public function __construct(\n        private {}: ${{}}\n    ) {{}}\n\n    public function {}(): {} {{\n        {}\n    }}\n}}",
					{
						i(1, "MyClass"),
						i(2, "ParentClass"),
						i(3, "MyInterface"),
						i(4, "string"),
						i(5, "field"),
						i(6, "method"),
						i(7, "void"),
						i(8),
					}
				)
			),
			s("fn", fmt("function {}({}): {} {{\n    {}\n}}", { i(1, "func"), i(2), i(3, "void"), i(4) })),
			s("arr", fmt("${} = [\n    {}\n];", { i(1, "arr"), i(2) })),
			s("foreach", fmt("foreach (${} as ${}) {{\n    {}\n}}", { i(1, "arr"), i(2, "item"), i(3) })),
			s(
				"try",
				fmt(
					"try {{\n    {}\n}} catch (\\Throwable $e) {{\n    {}\n}}",
					{ i(1), i(2, "echo $e->getMessage();") }
				)
			),
			s(
				"iface",
				fmt(
					"interface {} {{\n    public function {}({}): {};\n}}",
					{ i(1, "MyInterface"), i(2, "method"), i(3), i(4, "void") }
				)
			),
			s("trait", fmt("trait {} {{\n    {}\n}}", { i(1, "MyTrait"), i(2) })),
			s(
				"enum",
				fmt(
					"enum {}: {} {{\n    case {} = '{}';\n}}",
					{ i(1, "Status"), i(2, "string"), i(3, "Active"), i(4, "active") }
				)
			),
			s(
				"match",
				fmt(
					"$result = match({}) {{\n    {} => {},\n    default => {},\n}};",
					{ i(1, "$val"), i(2), i(3), i(4) }
				)
			),
			s("echo", fmt("echo {};", { i(1) })),
			s("var", fmt("var_dump({});", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- C#
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("cs", {
			s(
				"csbase",
				fmt(
					"using System;\n\nnamespace {}\n{{\n    class {}\n    {{\n        static void Main(string[] args)\n        {{\n            {}\n        }}\n    }}\n}}",
					{ i(1, "MyApp"), i(2, "Program"), i(3) }
				)
			),
			s(
				"cls",
				fmt(
					"public class {} : {}\n{{\n    public {}({}) {{}}\n\n    public {} {}({})\n    {{\n        {}\n    }}\n}}",
					{ i(1, "MyClass"), i(2, "object"), rep(1), i(3), i(4, "void"), i(5, "Method"), i(6), i(7) }
				)
			),
			s(
				"iface",
				fmt(
					"public interface {}\n{{\n    {} {}({});\n}}",
					{ i(1, "IMyInterface"), i(2, "void"), i(3, "Method"), i(4) }
				)
			),
			s("prop", fmt("public {} {} {{ get; set; }}", { i(1, "string"), i(2, "Name") })),
			s("fn", fmt("public {} {}({})\n{{\n    {}\n}}", { i(1, "void"), i(2, "Method"), i(3), i(4) })),
			s(
				"afn",
				fmt("public async Task<{}>{}Async({})\n{{\n    {}\n}}", { i(1, "T"), i(2, "Method"), i(3), i(4) })
			),
			s(
				"try",
				fmt("try\n{{\n    {}\n}}\ncatch (Exception ex)\n{{\n    Console.WriteLine(ex.Message);\n}}", { i(1) })
			),
			s("foreach", fmt("foreach (var {} in {})\n{{\n    {}\n}}", { i(1, "item"), i(2, "collection"), i(3) })),
			s(
				"linq",
				fmt(
					"{}.Where({} => {}).Select({} => {}).ToList();",
					{ i(1, "list"), i(2, "x"), i(3), i(4, "x"), i(5, "x") }
				)
			),
			s(
				"sw",
				fmt(
					"switch ({})\n{{\n    case {}:\n        {}\n        break;\n    default:\n        {}\n        break;\n}}",
					{ i(1, "val"), i(2), i(3), i(4) }
				)
			),
			s("rec", fmt("public record {}({} {});", { i(1, "MyRecord"), i(2, "string"), i(3, "Name") })),
			s("cl", fmt("Console.WriteLine({});", { i(1, '"Hello"') })),
			s("using", fmt("using {} = {};", { i(1), i(2) })),
			s("null", fmt("{} ?? throw new ArgumentNullException(nameof({}))", { i(1, "value"), rep(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Haskell
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("haskell", {
			s("hsbase", {
				t({ "module Main where", "", "main :: IO ()", "main = do", "    " }),
				i(1, 'putStrLn "Hello, World!"'),
			}),
			s("fn", fmt("{} :: {}\n{} {} = {}", { i(1, "func"), i(2, "a -> b"), rep(1), i(3, "x"), i(4) })),
			s("data", fmt("data {} = {}\n  deriving (Show, Eq)", { i(1, "MyType"), i(2, "Ctor") })),
			s("newtype", fmt("newtype {} = {} {}", { i(1, "MyType"), rep(1), i(2, "String") })),
			s(
				"cls",
				fmt("class {} {} where\n  {} :: {}", { i(1, "MyClass"), i(2, "a"), i(3, "method"), i(4, "a -> a") })
			),
			s(
				"inst",
				fmt("instance {} {} where\n  {} = {}", { i(1, "MyClass"), i(2, "MyType"), i(3, "method"), i(4) })
			),
			s("case", fmt("case {} of\n  {} -> {}\n  _ -> {}", { i(1, "val"), i(2, "pattern"), i(3), i(4) })),
			s("do", fmt("do\n  {} <- {}\n  return {}", { i(1, "x"), i(2), i(3, "x") })),
			s("where", fmt("{} = {}\n  where\n    {} = {}", { i(1, "result"), i(2), i(3, "helper"), i(4) })),
			s("import", fmt("import qualified {} as {}", { i(1, "Data.Map.Strict"), i(2, "Map") })),
			s("maybe", fmt("maybe {} {} {}", { i(1, "default"), i(2, "f"), i(3, "m") })),
			s("either", fmt("either {} {} {}", { i(1, "onLeft"), i(2, "onRight"), i(3, "e") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Scala
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("scala", {
			s("scbase", fmt("object {} extends App {{\n  {}\n}}", { i(1, "Main"), i(2) })),
			s(
				"fn",
				fmt(
					"def {}({}: {}): {} = {{\n  {}\n}}",
					{ i(1, "func"), i(2, "arg"), i(3, "String"), i(4, "Unit"), i(5) }
				)
			),
			s(
				"cls",
				fmt(
					"class {}({}: {}) {{\n  def {}(): {} = {}\n}}",
					{ i(1, "MyClass"), i(2, "val name"), i(3, "String"), i(4, "method"), i(5, "Unit"), i(6) }
				)
			),
			s("case", fmt("case class {}({}: {})", { i(1, "MyCase"), i(2, "field"), i(3, "String") })),
			s("obj", fmt("object {} {{\n  {}\n}}", { i(1, "MyObject"), i(2) })),
			s("trait", fmt("trait {} {{\n  def {}(): {}\n}}", { i(1, "MyTrait"), i(2, "method"), i(3, "Unit") })),
			s("match", fmt("{} match {{\n  case {} => {}\n  case _ => {}\n}}", { i(1, "val"), i(2), i(3), i(4) })),
			s("for", fmt("for {{\n  {} <- {}\n}} yield {}", { i(1, "x"), i(2), i(3, "x") })),
			s("opt", fmt("Option({}).getOrElse({})", { i(1), i(2) })),
			s("future", fmt("Future {{\n  {}\n}}", { i(1) })),
			s("pln", fmt("println({})", { i(1) })),
			s("given", fmt("given {}: {} = {}", { i(1, "name"), i(2, "MyType"), i(3) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Dart
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("dart", {
			s("dartbase", fmt("void main() {{\n  {}\n}}", { i(1) })),
			s(
				"cls",
				fmt(
					"class {} {{\n  final {} {};\n\n  const {}(this.{});\n\n  @override\n  String toString() => '{}(${}=${})'\n}}",
					{ i(1, "MyClass"), i(2, "String"), i(3, "name"), rep(1), rep(3), rep(1), rep(3), rep(3) }
				)
			),
			s("fn", fmt("{} {}({}) {{\n  {}\n}}", { i(1, "void"), i(2, "func"), i(3), i(4) })),
			s("afn", fmt("Future<{}> {}({}) async {{\n  {}\n}}", { i(1, "void"), i(2, "func"), i(3), i(4) })),
			s("list", fmt("final {} = <{}>[];", { i(1, "items"), i(2, "String") })),
			s("map", fmt("final {} = <{}, {}>{{}};", { i(1, "m"), i(2, "String"), i(3, "dynamic") })),
			s("for", fmt("for (final {} in {}) {{\n  {}\n}}", { i(1, "item"), i(2, "items"), i(3) })),
			s("try", fmt("try {{\n  {}\n}} catch (e) {{\n  {}\n}}", { i(1), i(2, "print(e)") })),
			s(
				"ext",
				fmt(
					"extension {} on {} {{\n  {} {}({}) {{\n    {}\n  }}\n}}",
					{ i(1, "MyExt"), i(2, "String"), i(3, "String"), i(4, "func"), i(5), i(6) }
				)
			),
			s("mixin", fmt("mixin {} {{\n  {}\n}}", { i(1, "MyMixin"), i(2) })),
			s("pln", fmt("print({});", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- R
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("r", {
			s("fn", fmt("{} <- function({}) {{\n  {}\n}}", { i(1, "func"), i(2), i(3) })),
			s("for", fmt("for ({} in {}) {{\n  {}\n}}", { i(1, "i"), i(2, "1:10"), i(3) })),
			s("apply", fmt("lapply({}, function({}) {{ {} }})", { i(1, "lst"), i(2, "x"), i(3) })),
			s("df", fmt("{} <- data.frame({} = c({}))", { i(1, "df"), i(2, "col"), i(3) })),
			s(
				"ggplot",
				fmt(
					'ggplot({}, aes(x = {}, y = {})) +\n  geom_{}() +\n  labs(title = "{}")',
					{ i(1, "df"), i(2), i(3), i(4, "point"), i(5) }
				)
			),
			s("pipe", fmt("{} |> {}({})", { i(1), i(2), i(3) })),
			s(
				"tryCatch",
				fmt("tryCatch({{\n  {}\n}}, error = function(e) {{\n  {}\n}})", { i(1), i(2, "message(e)") })
			),
			s("cat", fmt('cat("{}", {}, "\\n")', { i(1, "Result:"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Julia
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("julia", {
			s("fn", fmt("function {}({})\n    {}\nend", { i(1, "func"), i(2), i(3) })),
			s("struct", fmt("struct {}\n    {}: {}\nend", { i(1, "MyStruct"), i(2, "field"), i(3, "String") })),
			s(
				"mstruct",
				fmt("mutable struct {}\n    {}: {}\nend", { i(1, "MyStruct"), i(2, "field"), i(3, "String") })
			),
			s("for", fmt("for {} in {}\n    {}\nend", { i(1, "i"), i(2, "1:10"), i(3) })),
			s("comp", fmt("[{} for {} in {} if {}]", { i(1, "x"), i(2, "x"), i(3, "1:10"), i(4, "true") })),
			s("macro", fmt("macro {}({})\n    {}\nend", { i(1, "mymacro"), i(2, "expr"), i(3) })),
			s("mod", fmt("module {}\n    {}\nend", { i(1, "MyModule"), i(2) })),
			s("try", fmt("try\n    {}\ncatch e\n    {}\nend", { i(1), i(2, "println(e)") })),
			s("pln", fmt('println("{}", {})', { i(1), i(2) })),
			s("test", fmt('@testset "{}" begin\n    {}\nend', { i(1, "MyTests"), i(2, "@test true") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Shell / Bash
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("sh", {
			s("shbase", { t({ "#!/usr/bin/env bash", "set -euo pipefail", "IFS=$'\\n\\t'", "" }), i(1) }),
			s("fn", fmt("{}() {{\n    {}\n}}", { i(1, "func"), i(2) })),
			s("if", fmt("if {}; then\n    {}\nfi", { i(1, '[ -z "$1" ]'), i(2) })),
			s("ife", fmt("if {}; then\n    {}\nelse\n    {}\nfi", { i(1), i(2), i(3) })),
			s("for", fmt("for {} in {}; do\n    {}\ndone", { i(1, "item"), i(2, '"$@"'), i(3) })),
			s("while", fmt("while {}; do\n    {}\ndone", { i(1, "true"), i(2) })),
			s(
				"case",
				fmt(
					'case "$1" in\n    {})\n        {}\n        ;;\n    *)\n        {}\n        ;;\nesac',
					{ i(1, "option"), i(2), i(3) }
				)
			),
			s("arr", fmt("{}=({})", { i(1, "arr"), i(2, '"a" "b" "c"') })),
			s(
				"check",
				fmt(
					'if ! command -v {} &>/dev/null; then\n    echo "{} not found" >&2\n    exit 1\nfi',
					{ i(1, "curl"), rep(1) }
				)
			),
			s("trap", fmt("trap '{}' EXIT", { i(1, "cleanup") })),
			s("log", fmt('echo "[$(date +"%F %T")] {}" >&2', { i(1, "message") })),
			s("die", t('die() { echo "Error: $*" >&2; exit 1; }')),
			s(
				"usage",
				fmt(
					'usage() {{\n    cat <<EOF\nUsage: $(basename "$0") [options]\n\n{}\nEOF\n}}',
					{ i(1, "  -h  Show help") }
				)
			),
			s("here", fmt("cat <<EOF\n{}\nEOF", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Zsh
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("zsh", {
			s("zshbase", { t({ "#!/usr/bin/env zsh", "setopt ERR_EXIT PIPE_FAIL", "" }), i(1) }),
			s("fn", fmt("function {}() {{\n    {}\n}}", { i(1, "func"), i(2) })),
			s("autoload", fmt("autoload -Uz {}", { i(1, "compinit") })),
			s("alias", fmt("alias {}='{}'", { i(1, "ll"), i(2, "ls -la") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Fish
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("fish", {
			s("fn", fmt("function {}\n    {}\nend", { i(1, "func"), i(2) })),
			s("if", fmt("if {}\n    {}\nend", { i(1), i(2) })),
			s("for", fmt("for {} in {}\n    {}\nend", { i(1, "item"), i(2, "$argv"), i(3) })),
			s("switch", fmt("switch {}\ncase {}\n    {}\ncase '*'\n    {}\nend", { i(1, "$val"), i(2), i(3), i(4) })),
			s("abbr", fmt("abbr -a {} '{}'", { i(1, "g"), i(2, "git") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- HTML
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("html", {
			s(
				"html5",
				fmt(
					'<!DOCTYPE html>\n<html lang="{}">\n<head>\n    <meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n    <title>{}</title>\n</head>\n<body>\n    {}\n</body>\n</html>',
					{ i(1, "en"), i(2, "Document"), i(3) }
				)
			),
			s("div", fmt('<div class="{}">\n    {}\n</div>', { i(1), i(2) })),
			s("span", fmt('<span class="{}">{}</span>', { i(1), i(2) })),
			s("link", fmt('<link rel="stylesheet" href="{}">', { i(1) })),
			s("script", fmt('<script src="{}"></script>', { i(1) })),
			s("img", fmt('<img src="{}" alt="{}" loading="lazy" />', { i(1), i(2) })),
			s("a", fmt('<a href="{}">{}</a>', { i(1, "#"), i(2) })),
			s("input", fmt('<input type="{}" name="{}" id="{}" />', { i(1, "text"), i(2), i(3) })),
			s(
				"form",
				fmt(
					'<form action="{}" method="{}">\n    {}\n    <button type="submit">{}</button>\n</form>',
					{ i(1, "#"), i(2, "post"), i(3), i(4, "Submit") }
				)
			),
			s(
				"table",
				fmt(
					"<table>\n    <thead>\n        <tr><th>{}</th></tr>\n    </thead>\n    <tbody>\n        <tr><td>{}</td></tr>\n    </tbody>\n</table>",
					{ i(1, "Header"), i(2) }
				)
			),
			s(
				"nav",
				fmt('<nav>\n    <ul>\n        <li><a href="{}">{}</a></li>\n    </ul>\n</nav>', { i(1, "#"), i(2) })
			),
			s(
				"og",
				fmt(
					'<meta property="og:title" content="{}" />\n<meta property="og:description" content="{}" />\n<meta property="og:image" content="{}" />',
					{ i(1), i(2), i(3) }
				)
			),
			s("favicon", fmt('<link rel="icon" type="image/png" href="{}">', { i(1, "favicon.png") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- CSS
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("css", {
			s(
				"flex",
				fmt("display: flex;\nalign-items: {};\njustify-content: {};", { i(1, "center"), i(2, "center") })
			),
			s(
				"grid",
				fmt("display: grid;\ngrid-template-columns: {};\ngap: {};", { i(1, "repeat(3, 1fr)"), i(2, "1rem") })
			),
			s("media", fmt("@media (max-width: {}px) {{\n    {}\n}}", { i(1, "768"), i(2) })),
			s("var", fmt(":root {{\n    --{}: {};\n}}", { i(1, "color-primary"), i(2, "#3b82f6") })),
			s("anim", fmt("@keyframes {} {{\n    from {{ {} }}\n    to {{ {} }}\n}}", { i(1, "fade"), i(2), i(3) })),
			s("cls", fmt(".{} {{\n    {}\n}}", { i(1, "class"), i(2) })),
			s("hover", fmt(".{}:hover {{\n    {}\n}}", { i(1, "class"), i(2) })),
			s("abs", t("position: absolute;\ntop: 0;\nleft: 0;")),
			s("trans", fmt("transition: {} {}s ease;", { i(1, "all"), i(2, "0.3") })),
			s("shadow", fmt("box-shadow: 0 {}px {}px 0 rgba(0,0,0,{});", { i(1, "2"), i(2, "8"), i(3, "0.1") })),
			s("center", t("display: flex;\nalign-items: center;\njustify-content: center;")),
			s("reset", t("*,\n*::before,\n*::after {\n  box-sizing: border-box;\n  margin: 0;\n  padding: 0;\n}")),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- SCSS
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("scss", {
			s("mixin", fmt("@mixin {}({}) {{\n    {}\n}}", { i(1, "flex-center"), i(2), i(3) })),
			s("include", fmt("@include {}({});", { i(1), i(2) })),
			s("extend", fmt("@extend .{};", { i(1) })),
			s("fn", fmt("@function {}({}) {{\n    @return {};\n}}", { i(1, "rem"), i(2, "$px"), i(3) })),
			s(
				"each",
				fmt(
					"@each ${} in {} {{\n    .{}-#{{{${}}}} {{\n        {}\n    }}\n}}",
					{ i(1, "size"), i(2, "sm, md, lg"), i(3, "item"), i(4, "$size"), i(5) }
				)
			),
			s("for", fmt("@for ${} from {} through {} {{\n    {}\n}}", { i(1, "i"), i(2, "1"), i(3, "12"), i(4) })),
			s("map", fmt("${}:  (\n    {}: {},\n);", { i(1, "colors"), i(2, "primary"), i(3, "#3b82f6") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- React JSX
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("javascriptreact", {
			s(
				"comp",
				fmt(
					"import React from 'react';\n\nconst {} = ({{ {} }}) => {{\n    return (\n        <div>\n            {}\n        </div>\n    );\n}};\n\nexport default {};",
					{ i(1, "MyComp"), i(2), i(3), rep(1) }
				)
			),
			s("useState", fmt("const [{}, set{}] = useState({});", { i(1, "state"), i(2, "State"), i(3) })),
			s(
				"useEffect",
				fmt(
					"useEffect(() => {{\n    {}\n    return () => {{\n        {}\n    }};\n}}, [{}]);",
					{ i(1), i(2), i(3) }
				)
			),
			s("useRef", fmt("const {} = useRef({});", { i(1, "ref"), i(2, "null") })),
			s("useMemo", fmt("const {} = useMemo(() => {}, [{}]);", { i(1, "val"), i(2), i(3) })),
			s(
				"useCallback",
				fmt("const {} = useCallback(({}) => {{\n    {}\n}}, [{}]);", { i(1, "fn"), i(2), i(3), i(4) })
			),
			s(
				"useCtx",
				fmt(
					"const {} = createContext({});\nexport const use{} = () => useContext({});",
					{ i(1, "MyCtx"), i(2, "null"), i(3, "MyCtx"), rep(1) }
				)
			),
			s(
				"hook",
				fmt("function use{}({}) {{\n    {}\n    return {{ {} }};\n}}", { i(1, "MyHook"), i(2), i(3), i(4) })
			),
			s("frag", fmt("<>\n    {}\n</>", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- TypeScript React
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("typescriptreact", {
			s(
				"comp",
				fmt(
					"import React from 'react';\n\ninterface {}Props {{\n    {}\n}}\n\nconst {}: React.FC<{}Props> = ({{ {} }}) => {{\n    return (\n        <div>\n            {}\n        </div>\n    );\n}};\n\nexport default {};",
					{ i(1, "MyComp"), i(2), rep(1), rep(1), i(3), i(4), rep(1) }
				)
			),
			s(
				"useState",
				fmt(
					"const [{}, set{}] = useState<{}>({});",
					{ i(1, "state"), i(2, "State"), i(3, "string"), i(4, '""') }
				)
			),
			s(
				"useEffect",
				fmt(
					"useEffect(() => {{\n    {}\n    return () => {{\n        {}\n    }};\n}}, [{}]);",
					{ i(1), i(2), i(3) }
				)
			),
			s(
				"hook",
				fmt(
					"function use{}({}): {} {{\n    {}\n    return {{ {} }};\n}}",
					{ i(1, "MyHook"), i(2), i(3), i(4), i(5) }
				)
			),
			s("frag", fmt("<>\n    {}\n</>", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Vue
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("vue", {
			s(
				"vuebase",
				fmt(
					'<template>\n    <div>\n        {}\n    </div>\n</template>\n\n<script setup lang="ts">\n{}\n</script>\n\n<style scoped>\n{}\n</style>',
					{ i(1), i(2), i(3) }
				)
			),
			s("ref", fmt("const {} = ref<{}>({});", { i(1, "state"), i(2, "string"), i(3, '""') })),
			s("computed", fmt("const {} = computed(() => {});", { i(1, "val"), i(2) })),
			s("watch", fmt("watch({}, (newVal, oldVal) => {{\n    {}\n}});", { i(1), i(2) })),
			s(
				"emit",
				fmt("const emit = defineEmits<{{ (e: '{}', val: {}): void }}>();", { i(1, "update"), i(2, "string") })
			),
			s("props", fmt("const props = defineProps<{{ {}: {} }}>();", { i(1, "label"), i(2, "string") })),
			s("provide", fmt("provide('{}', {});", { i(1, "key"), i(2, "value") })),
			s("inject", fmt("const {} = inject<{}>('{}');", { i(1, "val"), i(2, "string"), i(3, "key") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Svelte
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("svelte", {
			s(
				"sveltebase",
				fmt(
					'<script lang="ts">\n    {}\n</script>\n\n<main>\n    {}\n</main>\n\n<style>\n    {}\n</style>',
					{ i(1), i(2), i(3) }
				)
			),
			s("each", fmt("{{#each {} as {}}}\n    {}\n{{/each}}", { i(1, "items"), i(2, "item"), i(3) })),
			s("if", fmt("{{#if {}}}\n    {}\n{{/if}}", { i(1, "cond"), i(2) })),
			s(
				"await",
				fmt(
					"{{#await {}}}\n    <p>Loading...</p>\n{{:then {}}}\n    {}\n{{:catch err}}\n    <p>{{err.message}}</p>\n{{/await}}",
					{ i(1, "promise"), i(2, "data"), i(3) }
				)
			),
			s("store", fmt("const {} = writable({});", { i(1, "store"), i(2) })),
			s(
				"dispatch",
				fmt(
					"import {{ createEventDispatcher }} from 'svelte';\nconst dispatch = createEventDispatcher();\ndispatch('{}', {});",
					{ i(1, "event"), i(2, "data") }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- SQL
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("sql", {
			s("sel", fmt("SELECT {}\nFROM {}\nWHERE {};", { i(1, "*"), i(2, "table"), i(3, "1=1") })),
			s(
				"join",
				fmt(
					"SELECT {}\nFROM {}\nINNER JOIN {} ON {}.{} = {}.{};",
					{ i(1, "*"), i(2, "a"), i(3, "b"), rep(2), i(4, "id"), rep(3), i(5, "a_id") }
				)
			),
			s(
				"ljoin",
				fmt(
					"SELECT {}\nFROM {}\nLEFT JOIN {} ON {}.{} = {}.{};",
					{ i(1, "*"), i(2, "a"), i(3, "b"), rep(2), i(4, "id"), rep(3), i(5, "a_id") }
				)
			),
			s(
				"create",
				fmt(
					"CREATE TABLE {} (\n    id SERIAL PRIMARY KEY,\n    {} VARCHAR(255) NOT NULL,\n    created_at TIMESTAMP DEFAULT NOW()\n);",
					{ i(1, "my_table"), i(2, "name") }
				)
			),
			s("insert", fmt("INSERT INTO {} ({})\nVALUES ({});", { i(1, "table"), i(2, "col"), i(3, "val") })),
			s(
				"update",
				fmt(
					"UPDATE {} SET {} = {} WHERE {} = {};",
					{ i(1, "table"), i(2, "col"), i(3, "val"), i(4, "id"), i(5, "1") }
				)
			),
			s("delete", fmt("DELETE FROM {} WHERE {} = {};", { i(1, "table"), i(2, "id"), i(3, "1") })),
			s("index", fmt("CREATE INDEX {} ON {} ({});", { i(1, "idx_name"), i(2, "table"), i(3, "col") })),
			s("cte", fmt("WITH {} AS (\n    {}\n)\nSELECT *\nFROM {};", { i(1, "cte"), i(2), rep(1) })),
			s("window", fmt("{} OVER (PARTITION BY {} ORDER BY {})", { i(1, "ROW_NUMBER()"), i(2), i(3) })),
			s("tx", fmt("BEGIN;\n    {}\nCOMMIT;", { i(1) })),
			s("view", fmt("CREATE OR REPLACE VIEW {} AS\n{};", { i(1, "my_view"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- GraphQL
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("graphql", {
			s(
				"query",
				fmt(
					"query {} {{\n    {}({}: {}) {{\n        {}\n    }}\n}}",
					{ i(1, "GetUser"), i(2, "user"), i(3, "id"), i(4, "$id"), i(5) }
				)
			),
			s(
				"mutation",
				fmt(
					"mutation {} {{\n    {}(input: $input) {{\n        {}\n    }}\n}}",
					{ i(1, "CreateUser"), i(2, "createUser"), i(3, "id") }
				)
			),
			s("frag", fmt("fragment {} on {} {{\n    {}\n}}", { i(1, "UserFields"), i(2, "User"), i(3) })),
			s("type", fmt("type {} {{\n    {}: {}\n}}", { i(1, "User"), i(2, "id"), i(3, "ID!") })),
			s("input", fmt("input {} {{\n    {}: {}\n}}", { i(1, "CreateUserInput"), i(2, "name"), i(3, "String!") })),
			s("sub", fmt("subscription {} {{\n    {}\n}}", { i(1, "OnUserCreated"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- YAML
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("yaml", {
			s(
				"ghaction",
				fmt(
					"name: {}\n\non:\n  push:\n    branches: [{}]\n  pull_request:\n    branches: [{}]\n\njobs:\n  {}:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - name: {}\n        run: |",
					{ i(1, "CI"), i(2, "main"), rep(2), i(3, "build"), i(4, "Run tests") }
				)
			),
			s(
				"k8deploy",
				fmt(
					"apiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: {}\nspec:\n  replicas: {}\n  selector:\n    matchLabels:\n      app: {}\n  template:\n    metadata:\n      labels:\n        app: {}\n    spec:\n      containers:\n        - name: {}\n          image: {}\n          ports:\n            - containerPort: {}",
					{ i(1, "my-app"), i(2, "2"), rep(1), rep(1), rep(1), i(3, "nginx:latest"), i(4, "80") }
				)
			),
			s(
				"k8svc",
				fmt(
					"apiVersion: v1\nkind: Service\nmetadata:\n  name: {}\nspec:\n  selector:\n    app: {}\n  ports:\n    - port: {}\n      targetPort: {}\n  type: {}",
					{ i(1, "my-svc"), i(2), i(3, "80"), i(4, "8080"), i(5, "ClusterIP") }
				)
			),
			s(
				"dc",
				fmt(
					'version: "3.8"\nservices:\n  {}:\n    image: {}\n    ports:\n      - "{}:{}"\n    environment:\n      {}: {}',
					{ i(1, "app"), i(2, "nginx"), i(3, "8080"), i(4, "80"), i(5, "ENV"), i(6, "value") }
				)
			),
			s(
				"secret",
				fmt(
					"apiVersion: v1\nkind: Secret\nmetadata:\n  name: {}\ntype: Opaque\nstringData:\n  {}: {}",
					{ i(1, "my-secret"), i(2, "key"), i(3, "value") }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- TOML
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("toml", {
			s("sect", fmt("[{}]\n{} = {}", { i(1, "section"), i(2, "key"), i(3, '"value"') })),
			s("dep", fmt('{} = "{}"', { i(1, "crate"), i(2, "1.0.0") })),
			s(
				"cargopkg",
				fmt(
					'[package]\nname = "{}"\nversion = "0.1.0"\nedition = "2021"\n\n[dependencies]',
					{ i(1, "my-crate") }
				)
			),
			s("arr", fmt("{} = [{}, {}]", { i(1, "key"), i(2), i(3) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- JSON
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("json", {
			s(
				"pkg",
				fmt(
					'{{\n  "name": "{}",\n  "version": "{}",\n  "description": "{}",\n  "scripts": {{\n    "build": "{}",\n    "test": "{}"\n  }},\n  "dependencies": {{}}\n}}',
					{ i(1), i(2, "1.0.0"), i(3), i(4), i(5, "jest") }
				)
			),
			s(
				"tsconfig",
				fmt(
					'{{\n  "compilerOptions": {{\n    "target": "{}",\n    "module": "{}",\n    "strict": true,\n    "outDir": "{}",\n    "rootDir": "{}"\n  }},\n  "include": ["{}"]\n}}',
					{ i(1, "ESNext"), i(2, "ESNext"), i(3, "./dist"), i(4, "./src"), i(5, "src") }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Markdown
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("markdown", {
			s("front", fmt("---\ntitle: {}\ndate: {}\nauthor: {}\ntags: [{}]\n---", { i(1), f(date), i(2), i(3) })),
			s("code", fmt("```{}\n{}\n```", { i(1, "bash"), i(2) })),
			s("link", fmt("[{}]({})", { i(1), i(2) })),
			s("img", fmt("![{}]({})", { i(1, "alt"), i(2, "url") })),
			s("table", {
				t({ "| Col1 | Col2 | Col3 |", "| ---- | ---- | ---- |", "| " }),
				i(1),
				t({ " | " }),
				i(2),
				t({ " | " }),
				i(3),
				t({ " |" }),
			}),
			s(
				"details",
				fmt("<details>\n<summary>{}</summary>\n\n{}\n\n</details>", { i(1, "Click to expand"), i(2) })
			),
			s("todo", { t("- [ ] "), i(1) }),
			s("done", { t("- [x] "), i(1) }),
			s("admon", fmt("> [!{}]\n> {}", { i(1, "NOTE"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- LaTeX
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("tex", {
			s(
				"doc",
				fmt(
					"\\documentclass{{{}}}\n\\usepackage[utf8]{{inputenc}}\n\\usepackage{{amsmath, amssymb}}\n\n\\title{{{}}}\n\\author{{{}}}\n\\date{{\\today}}\n\n\\begin{{document}}\n\\maketitle\n\n{}\n\n\\end{{document}}",
					{ i(1, "article"), i(2), i(3), i(4) }
				)
			),
			s("env", fmt("\\begin{{{}}}\n    {}\n\\end{{{}}}", { i(1, "itemize"), i(2), rep(1) })),
			s("item", fmt("\\item {}", { i(1) })),
			s("eq", fmt("\\[\n    {}\n\\]", { i(1) })),
			s("eqn", fmt("\\begin{{equation}}\n    {}\n\\label{{eq:{}}}\n\\end{{equation}}", { i(1), i(2) })),
			s("frac", fmt("\\frac{{{}}}{{{}}} ", { i(1), i(2) })),
			s("sum", fmt("\\sum_{{{}}}^{{{}}} ", { i(1, "i=0"), i(2, "n") })),
			s("int", fmt("\\int_{{{}}}^{{{}}} {} \\, d{}", { i(1, "0"), i(2, "\\infty"), i(3), i(4, "x") })),
			s(
				"fig",
				fmt(
					"\\begin{{figure}}[htbp]\n    \\centering\n    \\includegraphics[width={}]{{{}}}\n    \\caption{{{}}}\n    \\label{{fig:{}}}\n\\end{{figure}}",
					{ i(1, "0.8\\linewidth"), i(2), i(3), i(4) }
				)
			),
			s("sec", fmt("\\section{{{}}}\n\\label{{sec:{}}}\n\n{}", { i(1), i(2), i(3) })),
			s("ref", fmt("\\ref{{{}}} ", { i(1) })),
			s("cite", fmt("\\cite{{{}}} ", { i(1) })),
			s("bib", fmt("\\bibliography{{{}}}\n\\bibliographystyle{{{}}}", { i(1, "refs"), i(2, "plain") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Dockerfile
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("dockerfile", {
			s(
				"node",
				fmt(
					'FROM node:{}-alpine AS builder\nWORKDIR /app\nCOPY package*.json ./\nRUN npm ci --only=production\nCOPY . .\nRUN npm run build\n\nFROM node:{}-alpine\nWORKDIR /app\nCOPY --from=builder /app/dist ./dist\nCOPY --from=builder /app/node_modules ./node_modules\nEXPOSE {}\nCMD ["node", "dist/index.js"]',
					{ i(1, "20"), rep(1), i(2, "3000") }
				)
			),
			s(
				"python",
				fmt(
					'FROM python:{}-slim\nWORKDIR /app\nCOPY requirements.txt .\nRUN pip install --no-cache-dir -r requirements.txt\nCOPY . .\nEXPOSE {}\nCMD ["python", "{}"]',
					{ i(1, "3.12"), i(2, "8000"), i(3, "main.py") }
				)
			),
			s(
				"go",
				fmt(
					'FROM golang:{}-alpine AS builder\nWORKDIR /app\nCOPY go.mod go.sum ./\nRUN go mod download\nCOPY . .\nRUN CGO_ENABLED=0 GOOS=linux go build -o main .\n\nFROM scratch\nCOPY --from=builder /app/main /main\nEXPOSE {}\nCMD ["/main"]',
					{ i(1, "1.22"), i(2, "8080") }
				)
			),
			s("from", fmt("FROM {}", { i(1, "ubuntu:22.04") })),
			s("run", fmt("RUN {}", { i(1) })),
			s("copy", fmt("COPY {} {}", { i(1, "."), i(2, "/app") })),
			s("env", fmt("ENV {}={}", { i(1, "NODE_ENV"), i(2, "production") })),
			s("arg", fmt("ARG {}={}", { i(1, "VERSION"), i(2, "latest") })),
			s(
				"healthcheck",
				fmt(
					"HEALTHCHECK --interval=30s --timeout=5s \\\n  CMD {}",
					{ i(1, "curl -f http://localhost/ || exit 1") }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Makefile
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("make", {
			s("target", fmt("{}: {}\n\t{}\n\n.PHONY: {}", { i(1, "build"), i(2), i(3), rep(1) })),
			s(
				"base",
				fmt(
					".DEFAULT_GOAL := {}\n\n{}:\n\t{}\n\nclean:\n\t{}\n\n.PHONY: {} clean",
					{ i(1, "build"), rep(1), i(2), i(3), rep(1) }
				)
			),
			s("var", fmt("{} := {}", { i(1, "VAR"), i(2, "value") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- CMake
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("cmake", {
			s(
				"cmbase",
				fmt(
					"cmake_minimum_required(VERSION {})\nproject({} VERSION {})\n\nset(CMAKE_CXX_STANDARD {})\nset(CMAKE_CXX_STANDARD_REQUIRED ON)\n\nadd_executable({} {})",
					{ i(1, "3.20"), i(2, "MyProject"), i(3, "1.0"), i(4, "17"), i(5, "main"), i(6, "src/main.cpp") }
				)
			),
			s("lib", fmt("add_library({} {})", { i(1, "mylib"), i(2, "src/lib.cpp") })),
			s("link", fmt("target_link_libraries({} PRIVATE {})", { i(1, "target"), i(2) })),
			s("inc", fmt("target_include_directories({} PUBLIC {})", { i(1, "target"), i(2, "include") })),
			s(
				"find",
				fmt(
					"find_package({} REQUIRED)\ntarget_link_libraries({} PRIVATE {}::{})",
					{ i(1, "OpenCV"), i(2, "target"), rep(1), rep(1) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Terraform
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("terraform", {
			s("resource", fmt('resource "{}" "{}" {{\n    {}\n}}', { i(1, "aws_instance"), i(2, "example"), i(3) })),
			s(
				"variable",
				fmt(
					'variable "{}" {{\n    type        = {}\n    description = "{}"\n    default     = {}\n}}',
					{ i(1, "name"), i(2, "string"), i(3), i(4, '""') }
				)
			),
			s(
				"output",
				fmt('output "{}" {{\n    value       = {}\n    description = "{}"\n}}', { i(1, "name"), i(2), i(3) })
			),
			s(
				"module",
				fmt('module "{}" {{\n    source = "{}"\n    {}\n}}', { i(1, "vpc"), i(2, "./modules/vpc"), i(3) })
			),
			s("provider", fmt('provider "{}" {{\n    region = "{}"\n}}', { i(1, "aws"), i(2, "us-east-1") })),
			s("data", fmt('data "{}" "{}" {{\n    {}\n}}', { i(1, "aws_ami"), i(2, "ubuntu"), i(3) })),
			s("local", fmt("locals {{\n    {} = {}\n}}", { i(1, "name"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Elixir
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("elixir", {
			s("elxbase", fmt("defmodule {} do\n  {}\nend", { i(1, "MyModule"), i(2) })),
			s("fn", fmt("def {}({}) do\n  {}\nend", { i(1, "func"), i(2), i(3) })),
			s("pfn", fmt("defp {}({}) do\n  {}\nend", { i(1, "func"), i(2), i(3) })),
			s("case", fmt("case {} do\n  {} -> {}\n  _ -> {}\nend", { i(1), i(2), i(3), i(4) })),
			s("pipe", fmt("{}\n|> {}({})", { i(1), i(2), i(3) })),
			s("struct", fmt("defstruct [{}: {}]", { i(1, "field"), i(2, "nil") })),
			s(
				"gs",
				t(
					"use GenServer\n\ndef start_link(opts) do\n  GenServer.start_link(__MODULE__, opts, name: __MODULE__)\nend\n\ndef init(opts) do\n  {:ok, opts}\nend"
				)
			),
			s(
				"with",
				fmt(
					"with {{:ok, {}}} <- {},\n     {{:ok, {}}} <- {} do\n  {}\nelse\n  error -> error\nend",
					{ i(1, "a"), i(2), i(3, "b"), i(4), i(5) }
				)
			),
			s(
				"test",
				fmt(
					'defmodule {}Test do\n  use ExUnit.Case\n\n  test "{}" do\n    {}\n  end\nend',
					{ i(1, "MyModule"), i(2, "does something"), i(3) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Erlang
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("erlang", {
			s(
				"erlbase",
				fmt(
					"-module({}).\n-export([{}]).\n\n{}({}) ->\n    {}.",
					{ i(1, "mymod"), i(2, "start/0"), i(3, "start"), i(4), i(5) }
				)
			),
			s("fn", fmt("{}({}) ->\n    {}.", { i(1, "func"), i(2), i(3) })),
			s("case", fmt("case {} of\n    {} -> {};\n    _ -> {}\nend", { i(1), i(2), i(3), i(4) })),
			s("receive", fmt("receive\n    {{{}}} ->\n        {}\nend", { i(1, "msg"), i(2) })),
			s(
				"gen",
				t(
					"-behaviour(gen_server).\n\nstart_link() ->\n    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).\n\ninit([]) ->\n    {ok, #{}}."
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- F#
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("fsharp", {
			s("fsbase", fmt("[<EntryPoint>]\nlet main argv =\n    {}\n    0", { i(1) })),
			s("fn", fmt("let {} {} = {}", { i(1, "func"), i(2, "x"), i(3) })),
			s("rec", fmt("let rec {} {} = {}", { i(1, "func"), i(2, "n"), i(3) })),
			s(
				"type",
				fmt(
					"type {} =\n    | {}\n    | {}",
					{ i(1, "Shape"), i(2, "Circle of float"), i(3, "Square of float") }
				)
			),
			s("record", fmt("type {} = {{\n    {}: {}\n}}", { i(1, "Person"), i(2, "Name"), i(3, "string") })),
			s("match", fmt("match {} with\n| {} -> {}\n| _ -> {}", { i(1), i(2), i(3), i(4) })),
			s("async", fmt("async {{\n    let! {} = {}\n    return {}\n}}", { i(1, "result"), i(2), i(3) })),
			s("module", fmt("module {}\n\n{}", { i(1, "MyModule"), i(2) })),
			s("pln", fmt('printfn "{}" {}', { i(1, "%s"), i(2) })),
			s(
				"comp",
				fmt("seq {{\n    for {} in {} do\n        yield {}\n}}", { i(1, "i"), i(2, "1..10"), i(3, "i") })
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- OCaml
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("ocaml", {
			s("fn", fmt("let {} {} = {}", { i(1, "func"), i(2, "x"), i(3) })),
			s("rec", fmt("let rec {} {} = {}", { i(1, "func"), i(2, "n"), i(3) })),
			s(
				"type",
				fmt("type {} =\n  | {}\n  | {}", { i(1, "shape"), i(2, "Circle of float"), i(3, "Square of float") })
			),
			s("match", fmt("match {} with\n| {} -> {}\n| _ -> {}", { i(1), i(2), i(3), i(4) })),
			s("let", fmt("let {} =\n  {}\nin\n{}", { i(1, "x"), i(2), i(3) })),
			s("mod", fmt("module {} = struct\n  {}\nend", { i(1, "MyMod"), i(2) })),
			s("pln", fmt('Printf.printf "{}" {};;', { i(1, "%s\\n"), i(2) })),
			s("try", fmt("(try\n  {}\nwith _ ->\n  {})", { i(1), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Nim
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("nim", {
			s("nimbase", fmt("proc main() =\n  {}\n\nmain()", { i(1) })),
			s("proc", fmt("proc {}({}: {}): {} =\n  {}", { i(1, "func"), i(2, "x"), i(3, "int"), i(4, "int"), i(5) })),
			s("type", fmt("type\n  {} = object\n    {}: {}", { i(1, "MyObj"), i(2, "field"), i(3, "string") })),
			s("for", fmt("for {} in {}:\n  {}", { i(1, "i"), i(2, "0..9"), i(3) })),
			s("echo", fmt("echo {}", { i(1) })),
			s("tmpl", fmt("template {}({}: {}) =\n  {}", { i(1, "myTmpl"), i(2, "x"), i(3, "int"), i(4) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Zig
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("zig", {
			s(
				"zigbase",
				fmt(
					'const std = @import("std");\n\npub fn main() !void {{\n    const stdout = std.io.getStdOut().writer();\n    try stdout.print("{\\n}", .{{{}}});\n}}',
					{ i(1, "Hello, World!"), i(2) }
				)
			),
			s(
				"fn",
				fmt(
					"pub fn {}({}: {}) {} {{\n    {}\n}}",
					{ i(1, "func"), i(2, "arg"), i(3, "u32"), i(4, "u32"), i(5) }
				)
			),
			s(
				"struct",
				fmt("const {} = struct {{\n    {}: {},\n}};", { i(1, "MyStruct"), i(2, "field"), i(3, "u32") })
			),
			s("for", fmt("for ({}) |{}| {{\n    {}\n}}", { i(1, "items"), i(2, "item"), i(3) })),
			s("while", fmt("while ({}) {{\n    {}\n}}", { i(1, "true"), i(2) })),
			s("errdef", fmt("const {} = error{{\n    {},\n}};", { i(1, "MyError"), i(2, "SomethingFailed") })),
			s("test", fmt('test "{}" {{\n    {}\n}}', { i(1, "something"), i(2) })),
			s(
				"alloc",
				fmt(
					"const {} = try allocator.{}<{}>({});\ndefer allocator.free({});",
					{ i(1, "buf"), i(2, "alloc"), i(3, "u8"), i(4, "1024"), rep(1) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Perl
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("perl", {
			s("perlbase", { t({ "#!/usr/bin/env perl", "use strict;", "use warnings;", "" }), i(1) }),
			s("sub", fmt("sub {} {{\n    my ({}) = @_;\n    {}\n}}", { i(1, "func"), i(2, "$arg"), i(3) })),
			s("for", fmt("foreach my ${} (@{}) {{\n    {}\n}}", { i(1, "item"), i(2, "arr"), i(3) })),
			s("regex", fmt("if (${} =~ /{}/g) {{ {} }}", { i(1, "str"), i(2, "pattern"), i(3) })),
			s("hash", fmt("my %{} = ({} => {});", { i(1, "h"), i(2, "key"), i(3, "val") })),
			s("arr", fmt("my @{} = ({});", { i(1, "arr"), i(2) })),
			s("print", fmt('print "{}\\n";', { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Crystal
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("crystal", {
			s(
				"cls",
				fmt(
					"class {}\n  def initialize(@{} : {})\n  end\n\n  def {}\n    {}\n  end\nend",
					{ i(1, "MyClass"), i(2, "name"), i(3, "String"), i(4, "method"), i(5) }
				)
			),
			s(
				"fn",
				fmt("def {}({} : {}) : {}\n  {}\nend", { i(1, "func"), i(2, "arg"), i(3, "String"), i(4, "Nil"), i(5) })
			),
			s("puts", fmt("puts {}", { i(1) })),
			s("pp", fmt("pp {}", { i(1) })),
			s(
				"struct",
				fmt(
					"struct {}\n  getter {}: {}\n  def initialize(@{}: {})\n  end\nend",
					{ i(1, "MyStruct"), i(2, "name"), i(3, "String"), rep(2), rep(3) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Clojure
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("clojure", {
			s("ns", fmt("(ns {}\n  (:require [{}]))", { i(1, "my-ns"), i(2) })),
			s("fn", fmt("(defn {} [{}]\n  {})", { i(1, "func"), i(2), i(3) })),
			s("let", fmt("(let [{} {}]\n  {})", { i(1, "x"), i(2), i(3) })),
			s("map", fmt("(map {} {})", { i(1, "#(inc %)"), i(2, "coll") })),
			s("filter", fmt("(filter {} {})", { i(1, "even?"), i(2, "coll") })),
			s("reduce", fmt("(reduce {} {} {})", { i(1, "+"), i(2, "0"), i(3, "coll") })),
			s("def", fmt("(def {} {})", { i(1, "my-var"), i(2) })),
			s("pln", fmt("(println {})", { i(1) })),
			s("thread", fmt("(-> {}\n    ({})\n    ({}))", { i(1), i(2), i(3) })),
			s("when", fmt("(when {}\n  {})", { i(1, "cond"), i(2) })),
			s("cond", fmt("(cond\n  {} {}\n  :else {})", { i(1, "(pred? x)"), i(2), i(3) })),
			s("spec", fmt("(s/def ::{}\n  {})", { i(1, "my-key"), i(2, "string?") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Scheme / Racket
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("scheme", {
			s("fn", fmt("(define ({} {})\n  {})", { i(1, "func"), i(2, "x"), i(3) })),
			s("let", fmt("(let (({} {}))\n  {})", { i(1, "x"), i(2), i(3) })),
			s("letstar", fmt("(let* (({} {})\n       ({} {}))\n  {})", { i(1, "x"), i(2), i(3, "y"), i(4), i(5) })),
			s("cond", fmt("(cond\n  [{} {}]\n  [else {}])", { i(1, "#t"), i(2), i(3) })),
			s("lambda", fmt("(lambda ({}) {})", { i(1, "x"), i(2) })),
			s("disp", fmt("(display {})\n(newline)", { i(1) })),
			s("map", fmt("(map {} {})", { i(1, "func"), i(2, "lst") })),
			s("filter", fmt("(filter {} {})", { i(1, "pred?"), i(2, "lst") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Groovy / Jenkins Pipeline
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("groovy", {
			s(
				"pipeline",
				fmt(
					"pipeline {{\n    agent any\n    stages {{\n        stage('{}') {{\n            steps {{\n                {}\n            }}\n        }}\n    }}\n}}",
					{ i(1, "Build"), i(2, "sh 'make build'") }
				)
			),
			s("fn", fmt("def {}({}) {{\n    {}\n}}", { i(1, "func"), i(2), i(3) })),
			s(
				"cls",
				fmt(
					"class {} {{\n    {}\n\n    {}({}) {{\n        {}\n    }}\n}}",
					{ i(1, "MyClass"), i(2), rep(1), i(3), i(4) }
				)
			),
			s("pln", fmt("println {}", { i(1) })),
			s(
				"eachfile",
				fmt(
					"dir('{}') {{\n    def files = findFiles(glob: '{}')\n    files.each {{ f ->\n        {}\n    }}\n}}",
					{ i(1, "."), i(2, "**/*.txt"), i(3) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Nginx
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("nginx", {
			s(
				"server",
				fmt(
					"server {{\n    listen {};\n    server_name {};\n\n    root {};\n    index index.html;\n\n    location / {{\n        {}\n    }}\n}}",
					{ i(1, "80"), i(2, "example.com"), i(3, "/var/www/html"), i(4, "try_files $uri $uri/ =404;") }
				)
			),
			s(
				"ssl",
				fmt(
					"server {{\n    listen 443 ssl http2;\n    server_name {};\n\n    ssl_certificate {};\n    ssl_certificate_key {};\n    ssl_protocols TLSv1.2 TLSv1.3;\n\n    location / {{\n        {}\n    }}\n}}",
					{ i(1, "example.com"), i(2, "/etc/ssl/cert.pem"), i(3, "/etc/ssl/key.pem"), i(4) }
				)
			),
			s(
				"proxy",
				fmt(
					"location {} {{\n    proxy_pass http://{}:{};\n    proxy_set_header Host $host;\n    proxy_set_header X-Real-IP $remote_addr;\n}}",
					{ i(1, "/api"), i(2, "localhost"), i(3, "3000") }
				)
			),
			s("redir", t("return 301 https://$host$request_uri;")),
			s(
				"gzip",
				t(
					"gzip on;\ngzip_types text/plain text/css application/json application/javascript;\ngzip_min_length 1000;"
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Vimscript
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("vim", {
			s("fn", fmt("function! {}({})\n  {}\nendfunction", { i(1, "MyFunc"), i(2), i(3) })),
			s("cmd", fmt("command! {} {}", { i(1, "MyCmd"), i(2) })),
			s("au", fmt("autocmd {} {} {}", { i(1, "BufWritePre"), i(2, "*.lua"), i(3) })),
			s("map", fmt("nnoremap {} {}", { i(1, "<leader>x"), i(2, ":echo 'hi'<CR>") })),
			s(
				"aug",
				fmt(
					"augroup {}\n    au!\n    autocmd {} {} {}\naugroup END",
					{ i(1, "MyGroup"), i(2, "BufWritePre"), i(3, "*"), i(4) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Nix
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("nix", {
			s(
				"shell",
				fmt(
					"{{ pkgs ? import <nixpkgs> {{}} }}:\npkgs.mkShell {{\n    buildInputs = with pkgs; [\n        {}\n    ];\n    shellHook = ''\n        {}\n    '';\n}}",
					{ i(1, "git curl"), i(2) }
				)
			),
			s(
				"pkg",
				fmt(
					'{{ lib, buildPythonPackage, fetchPypi }}:\nbuildPythonPackage rec {{\n    pname = "{}";\n    version = "{}";\n    src = fetchPypi {{\n        inherit pname version;\n        sha256 = "{}";\n    }};\n}}',
					{ i(1, "my-pkg"), i(2, "1.0.0"), i(3, "sha256-...") }
				)
			),
			s(
				"flake",
				fmt(
					'{{\n  description = "{}";\n  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";\n  outputs = {{ self, nixpkgs }}: {{\n    packages.x86_64-linux.default = {};\n  }};\n}}',
					{ i(1, "My flake"), i(2) }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Gleam
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("gleam", {
			s(
				"fn",
				fmt(
					"pub fn {}({}: {}) -> {} {{\n  {}\n}}",
					{ i(1, "func"), i(2, "arg"), i(3, "String"), i(4, "String"), i(5) }
				)
			),
			s("case", fmt("case {} {{\n  {} -> {}\n  _ -> {}\n}}", { i(1), i(2), i(3), i(4) })),
			s("type", fmt("pub type {} {{\n  {}\n}}", { i(1, "MyType"), i(2, "Variant") })),
			s("import", fmt("import {}", { i(1, "gleam/io") })),
			s("pln", fmt('io.println("{}")', { i(1) })),
			s("let", fmt("let {} = {}", { i(1, "x"), i(2) })),
			s("use", fmt("use {} <- {}", { i(1, "x"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Odin
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("odin", {
			s(
				"odinbase",
				fmt(
					'package {}\n\nimport "core:fmt"\n\nmain :: proc() {{\n    {}\n}}',
					{ i(1, "main"), i(2, 'fmt.println("Hello!")') }
				)
			),
			s(
				"proc",
				fmt(
					"{} :: proc({}: {}) -> {} {{\n    {}\n}}",
					{ i(1, "func"), i(2, "arg"), i(3, "int"), i(4, "int"), i(5) }
				)
			),
			s("struct", fmt("{} :: struct {{\n    {}: {},\n}}", { i(1, "MyStruct"), i(2, "field"), i(3, "int") })),
			s("for", fmt("for {}, {} in {} {{\n    {}\n}}", { i(1, "i"), i(2, "v"), i(3, "arr"), i(4) })),
			s("when", fmt("when {} {{\n    {}\n}}", { i(1, "ODIN_OS == .Windows"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- V (vlang)
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("vlang", {
			s("vbase", fmt("module main\n\nfn main() {{\n    {}\n}}", { i(1) })),
			s("fn", fmt("fn {}({} {}) {} {{\n    {}\n}}", { i(1, "func"), i(2, "x"), i(3, "int"), i(4, "int"), i(5) })),
			s("struct", fmt("struct {} {{\n    {}: {}\n}}", { i(1, "MyStruct"), i(2, "name"), i(3, "string") })),
			s("for", fmt("for {} in {} {{\n    {}\n}}", { i(1, "item"), i(2, "items"), i(3) })),
			s("pln", fmt("println({})", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Solidity
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("solidity", {
			s(
				"sol",
				fmt(
					"// SPDX-License-Identifier: {}\npragma solidity ^{};\n\ncontract {} {{\n    {}\n\n    constructor({}) {{\n        {}\n    }}\n\n    function {}({}) public {} {{\n        {}\n    }}\n}}",
					{
						i(1, "MIT"),
						i(2, "0.8.20"),
						i(3, "MyContract"),
						i(4),
						i(5),
						i(6),
						i(7, "func"),
						i(8),
						i(9, "view returns (uint256)"),
						i(10),
					}
				)
			),
			s("event", fmt("event {}({} indexed {});", { i(1, "Transfer"), i(2, "address"), i(3, "from") })),
			s("mapping", fmt("mapping({} => {}) public {};", { i(1, "address"), i(2, "uint256"), i(3, "balances") })),
			s(
				"modifier",
				fmt(
					'modifier {}() {{\n    require({}, "{}");\n    _;\n}}',
					{ i(1, "onlyOwner"), i(2, "msg.sender == owner"), i(3, "Not owner") }
				)
			),
			s("emit", fmt("emit {}({});", { i(1, "Transfer"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Protocol Buffers
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("proto", {
			s(
				"msg",
				fmt(
					"message {} {{\n    {} {} = {};\n}}",
					{ i(1, "MyMessage"), i(2, "string"), i(3, "name"), i(4, "1") }
				)
			),
			s(
				"svc",
				fmt(
					"service {} {{\n    rpc {}({}) returns ({});\n}}",
					{ i(1, "MyService"), i(2, "GetUser"), i(3, "GetUserRequest"), i(4, "GetUserResponse") }
				)
			),
			s("enum", fmt("enum {} {{\n    {} = 0;\n}}", { i(1, "Status"), i(2, "UNKNOWN") })),
			s(
				"head",
				fmt(
					'syntax = "proto3";\npackage {};\n\noption go_package = "{}";',
					{ i(1, "mypackage"), i(2, "./gen/go") }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Assembly (NASM x86-64)
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("asm", {
			s("asmbase", {
				t({
					"section .data",
					"",
					"section .bss",
					"",
					"section .text",
					"    global _start",
					"",
					"_start:",
					"    ",
				}),
				i(1, "; entry"),
				t({ "", "", "    mov eax, 60", "    xor edi, edi", "    syscall" }),
			}),
			s(
				"fn",
				fmt("{}:\n    push rbp\n    mov rbp, rsp\n    {}\n    pop rbp\n    ret", { i(1, "my_func"), i(2) })
			),
			s("write", t("mov rax, 1\nmov rdi, 1\nlea rsi, [msg]\nmov rdx, msg_len\nsyscall")),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- PowerShell
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("ps1", {
			s(
				"fn",
				fmt(
					"function {} {{\n    param(\n        [{}]${}\n    )\n    {}\n}}",
					{ i(1, "Invoke-Something"), i(2, "string"), i(3, "Name"), i(4) }
				)
			),
			s("try", fmt("try {{\n    {}\n}} catch {{\n    Write-Error $_\n}}", { i(1) })),
			s("for", fmt("foreach (${} in ${}) {{\n    {}\n}}", { i(1, "item"), i(2, "items"), i(3) })),
			s("write", fmt("Write-Host {}", { i(1, '"Hello"') })),
			s(
				"param",
				fmt(
					"[CmdletBinding()]\nparam(\n    [Parameter(Mandatory=${})]\n    [{}]${} = {}\n)",
					{ i(1, "false"), i(2, "string"), i(3, "Name"), i(4, '""') }
				)
			),
			s("mod", fmt("$ErrorActionPreference = 'Stop'\nSet-StrictMode -Version Latest\n\n{}", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Prisma ORM
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("prisma", {
			s(
				"model",
				fmt(
					"model {} {{\n    id        Int      @id @default(autoincrement())\n    {}        {}\n    createdAt DateTime @default(now())\n    updatedAt DateTime @updatedAt\n}}",
					{ i(1, "User"), i(2, "name"), i(3, "String") }
				)
			),
			s(
				"rel",
				fmt(
					"{} {} @relation(fields: [{}], references: [{}])",
					{ i(1, "user"), i(2, "User"), i(3, "userId"), i(4, "id") }
				)
			),
			s("enum", fmt("enum {} {{\n    {}\n}}", { i(1, "Role"), i(2, "USER\n    ADMIN") })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- MDX
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("mdx", {
			s("comp", fmt("<{} />", { i(1, "MyComponent") })),
			s("import", fmt('import {{ {} }} from "{}";', { i(1), i(2) })),
			s("front", fmt("---\ntitle: {}\ndescription: {}\n---", { i(1), i(2) })),
			s("code", fmt("```{}\n{}\n```", { i(1, "js"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Mermaid diagrams (often embedded in markdown)
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("mermaid", {
			s(
				"flow",
				fmt(
					"flowchart TD\n    A[{}] --> B{{{{?}}}}\n    B -->|Yes| C[{}]\n    B -->|No| D[{}]",
					{ i(1, "Start"), i(2, "Yes path"), i(3, "No path") }
				)
			),
			s(
				"seq",
				fmt(
					"sequenceDiagram\n    participant {} as {}\n    participant {} as {}\n    {} ->> {}: {}\n    {} -->> {}: {}",
					{
						i(1, "A"),
						i(2, "Alice"),
						i(3, "B"),
						i(4, "Bob"),
						rep(1),
						rep(3),
						i(5, "Request"),
						rep(3),
						rep(1),
						i(6, "Response"),
					}
				)
			),
			s("er", fmt("erDiagram\n    {} ||--o{{ {} : {}", { i(1, "USER"), i(2, "POST"), i(3, "writes") })),
			s(
				"gantt",
				fmt("gantt\n    title {}\n    dateFormat YYYY-MM-DD\n    section {}\n    {} : {}, {}, {}", {
					i(1, "Project Plan"),
					i(2, "Phase 1"),
					i(3, "Task 1"),
					i(4, "a1"),
					i(5, "2024-01-01"),
					i(6, "7d"),
				})
			),
			s(
				"class",
				fmt(
					"classDiagram\n    class {} {{\n        +{} {}\n        +{}()\n    }}",
					{ i(1, "Animal"), i(2, "String"), i(3, "name"), i(4, "sound") }
				)
			),
			s(
				"pie",
				fmt(
					'pie title {}\n    "{}" : {}\n    "{}" : {}',
					{ i(1, "Stats"), i(2, "A"), i(3, "42"), i(4, "B"), i(5, "58") }
				)
			),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- D language
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("d", {
			s("dbase", fmt("import std.stdio;\n\nvoid main() {{\n    {}\n}}", { i(1, 'writeln("Hello, World!");') })),
			s("fn", fmt("{} {}({}) {{\n    {}\n}}", { i(1, "void"), i(2, "func"), i(3), i(4) })),
			s(
				"cls",
				fmt(
					"class {} {{\n    this({}) {{\n        {}\n    }}\n    {}\n}}",
					{ i(1, "MyClass"), i(2), i(3), i(4) }
				)
			),
			s("struct", fmt("struct {} {{\n    {} {};\n}}", { i(1, "MyStruct"), i(2, "string"), i(3, "name") })),
			s("foreach", fmt("foreach ({}, {}; {}) {{\n    {}\n}}", { i(1, "i"), i(2, "v"), i(3, "arr"), i(4) })),
			s("pln", fmt("writeln({});", { i(1) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- Objective-C
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("objc", {
			s(
				"objcbase",
				fmt(
					"#import <Foundation/Foundation.h>\n\nint main(int argc, const char * argv[]) {{\n    @autoreleasepool {{\n        {}\n    }}\n    return 0;\n}}",
					{ i(1, 'NSLog(@"Hello, World!");') }
				)
			),
			s(
				"cls",
				fmt(
					"@interface {} : {}\n@property (nonatomic, strong) {} *{};\n- (instancetype)initWith{}:({} *){};\n@end\n\n@implementation {}\n- (instancetype)initWith{}:({} *){} {{\n    self = [super init];\n    if (self) {{\n        _{} = {};\n    }}\n    return self;\n}}\n@end",
					{
						i(1, "MyClass"),
						i(2, "NSObject"),
						i(3, "NSString"),
						i(4, "name"),
						rep(4),
						rep(3),
						rep(4),
						rep(1),
						rep(4),
						rep(3),
						rep(4),
						rep(4),
						rep(4),
					}
				)
			),
			s("fn", fmt("- ({}) {} {{\n    {}\n}}", { i(1, "void"), i(2, "method"), i(3) })),
			s("pln", fmt('NSLog(@"{}", {});', { i(1, "%@"), i(2) })),
		})

		-- ─────────────────────────────────────────────────────────────────────────
		-- MATLAB / Octave
		-- ─────────────────────────────────────────────────────────────────────────
		ls.add_snippets("matlab", {
			s("fn", fmt("function {} = {}({})\n    {}\nend", { i(1, "out"), i(2, "func"), i(3, "x"), i(4) })),
			s("for", fmt("for {} = {}:{}\n    {}\nend", { i(1, "i"), i(2, "1"), i(3, "10"), i(4) })),
			s("while", fmt("while {}\n    {}\nend", { i(1, "true"), i(2) })),
			s("if", fmt("if {}\n    {}\nelse\n    {}\nend", { i(1, "cond"), i(2), i(3) })),
			s("try", fmt("try\n    {}\ncatch e\n    {}\nend", { i(1), i(2, "disp(e.message)") })),
			s("pln", fmt("fprintf('{}\\n', {});", { i(1, "%s"), i(2) })),
		})
	end,
}
