local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("typescriptreact", { "javascript", "typescript" })

-- JavaScript snippets
ls.add_snippets("javascript", {
	-- Console methods
	s("lg", {
		t("console.log("),
		i(1, "message"),
		t(");"),
	}),

	-- Functions
	s("fun", {
		t("function "),
		i(1, "name"),
		t("("),
		i(2, "args"),
		t({ ") {", "\t" }),
		i(3, "// body"),
		t({ "", "}" }),
	}),
	s("fn", {
		t("const "),
		i(1, "name"),
		t(" = ("),
		i(2, "args"),
		t({ ") => {", "\t" }),
		i(3, "// body"),
		t({ "", "};" }),
	}),
	s("afn", {
		t("("),
		i(1, "args"),
		t(") => "),
		i(2, "expression"),
		t(";"),
	}),

	-- React components
	s("rfc", {
		t("function "),
		i(1, "ComponentName"),
		t({ "(props) {", "\treturn (", "\t\t" }),
		i(2, "<div></div>"),
		t({ "", "\t);", "}" }),
	}),
	s("rafc", {
		t("const "),
		i(1, "ComponentName"),
		t({ " = (props) => {", "\treturn (", "\t\t" }),
		i(2, "<div></div>"),
		t({ "", "\t);", "};" }),
	}),
	s("rafce", {
		t("const "),
		i(1, "ComponentName"),
		t({ " = (props) => {", "\treturn (", "\t\t" }),
		i(2, "<div></div>"),
		t({ "", "\t);", "};", "", "export default " }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t(";"),
	}),

	-- React hooks
	s("us", {
		t("const ["),
		i(1, "state"),
		t(", set"),
		i(2, "State"),
		t("] = useState("),
		i(3, "initialValue"),
		t(");"),
	}),
	s("ue", {
		t({ "useEffect(() => {", "\t" }),
		i(1, "// effect"),
		t({ "", "}, [" }),
		i(2, "dependencies"),
		t("]);"),
	}),
	s("ur", {
		t("const "),
		i(1, "ref"),
		t(" = useRef("),
		i(2, "initialValue"),
		t(");"),
	}),

	-- Control flow
	s("if", {
		t("if ("),
		i(1, "condition"),
		t({ ") {", "\t" }),
		i(2, "// body"),
		t({ "", "}" }),
	}),
	s("ife", {
		t("if ("),
		i(1, "condition"),
		t({ ") {", "\t" }),
		i(2, "// if body"),
		t({ "", "} else {", "\t" }),
		i(3, "// else body"),
		t({ "", "}" }),
	}),
	s("trn", {
		i(1, "condition"),
		t(" ? "),
		i(2, "true"),
		t(" : "),
		i(3, "false"),
	}),

	-- Try-catch
	s("try", {
		t({ "try {", "\t" }),
		i(1, "// try body"),
		t({ "", "} catch (error) {", "\t" }),
		i(2, "console.error(error);"),
		t({ "", "}" }),
	}),
	s("tryf", {
		t({ "try {", "\t" }),
		i(1, "// try body"),
		t({ "", "} catch (error) {", "\t" }),
		i(2, "console.error(error);"),
		t({ "", "} finally {", "\t" }),
		i(3, "// cleanup"),
		t({ "", "}" }),
	}),

	-- Loops
	s("for", {
		t("for (let i = 0; i < "),
		i(1, "length"),
		t({ "; i++) {", "\t" }),
		i(2, "// body"),
		t({ "", "}" }),
	}),
	s("foro", {
		t("for (const "),
		i(1, "item"),
		t(" of "),
		i(2, "array"),
		t({ ") {", "\t" }),
		i(3, "// body"),
		t({ "", "}" }),
	}),
	s("fori", {
		t("for (const "),
		i(1, "key"),
		t(" in "),
		i(2, "object"),
		t({ ") {", "\t" }),
		i(3, "// body"),
		t({ "", "}" }),
	}),
	s("wh", {
		t("while ("),
		i(1, "condition"),
		t({ ") {", "\t" }),
		i(2, "// body"),
		t({ "", "}" }),
	}),

	-- Array methods
	s("map", {
		i(1, "array"),
		t(".map(("),
		i(2, "item"),
		t(") => "),
		i(3, "item"),
		t(")"),
	}),
	s("filter", {
		i(1, "array"),
		t(".filter(("),
		i(2, "item"),
		t(") => "),
		i(3, "condition"),
		t(")"),
	}),
	s("find", {
		i(1, "array"),
		t(".find(("),
		i(2, "item"),
		t(") => "),
		i(3, "condition"),
		t(")"),
	}),
	s("reduce", {
		i(1, "array"),
		t(".reduce(("),
		i(2, "acc"),
		t(", "),
		i(3, "item"),
		t(") => "),
		i(4, "acc"),
		t(", "),
		i(5, "initialValue"),
		t(")"),
	}),
	s("fe", {
		i(1, "array"),
		t({ ".forEach((item) => {", "\t" }),
		i(2, "// body"),
		t({ "", "})" }),
	}),

	-- Promise
	s("prom", {
		t({ "new Promise((resolve, reject) => {", "\t" }),
		i(1, "// body"),
		t({ "", "})" }),
	}),
	s("then", {
		t({ ".then((", "" }),
		i(1, "result"),
		t({ ") => {", "\t" }),
		i(2, "// body"),
		t({ "", "})" }),
	}),
	s("catch", {
		t(".catch(("),
		i(1, "error"),
		t({ ") => {", "\t" }),
		i(2, "console.error(error);"),
		t({ "", "})" }),
	}),

	-- Object/Destructuring
	s("dst", {
		t("const { "),
		i(1, "property"),
		t(" } = "),
		i(2, "object"),
		t(";"),
	}),
	s("dsta", {
		t("const ["),
		i(1, "item"),
		t("] = "),
		i(2, "array"),
		t(";"),
	}),

	-- Import/Export
	s("imp", {
		t("import "),
		i(1, "module"),
		t(" from '"),
		i(2, "path"),
		t("';"),
	}),
	s("impd", {
		t("import { "),
		i(1, "component"),
		t(" } from '"),
		i(2, "path"),
		t("';"),
	}),
	s("exp", {
		t("export "),
		i(1, "const"),
		t(" "),
		i(2, "name"),
		t(";"),
	}),
	s("expd", {
		t("export default "),
		i(1, "name"),
		t(";"),
	}),
})

-- TypeScript snippets
ls.add_snippets("typescript", {
	-- Console methods
	s("lg", {
		t("console.log("),
		i(1, "message"),
		t(");"),
	}),
	s("ce", {
		t("console.error("),
		i(1, "error"),
		t(");"),
	}),
	s("cw", {
		t("console.warn("),
		i(1, "warning"),
		t(");"),
	}),

	-- TypeScript specific
	s("int", {
		t("interface "),
		i(1, "Name"),
		t({ " {", "\t" }),
		i(2, "property: type;"),
		t({ "", "}" }),
	}),
	s("type", {
		t("type "),
		i(1, "Name"),
		t(" = "),
		i(2, "type"),
		t(";"),
	}),
	s("enum", {
		t("enum "),
		i(1, "Name"),
		t({ " {", "\t" }),
		i(2, "VALUE"),
		t({ "", "}" }),
	}),

	-- Typed functions
	s("fun", {
		t("function "),
		i(1, "name"),
		t("("),
		i(2, "args"),
		t("): "),
		i(3, "ReturnType"),
		t({ " {", "\t" }),
		i(4, "// body"),
		t({ "", "}" }),
	}),
	s("af", {
		t("const "),
		i(1, "name"),
		t(" = ("),
		i(2, "args"),
		t("): "),
		i(3, "ReturnType"),
		t({ " => {", "\t" }),
		i(4, "// body"),
		t({ "", "};" }),
	}),

	-- React with TypeScript
	s("rfc", {
		t("interface "),
		i(1, "ComponentName"),
		t({ "Props {", "\t" }),
		i(2, "// props"),
		t({ "", "}", "", "function " }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t("(props: "),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t({ "Props) {", "\treturn (", "\t\t" }),
		i(3, "<div></div>"),
		t({ "", "\t);", "}" }),
	}),
	s("rafc", {
		t("interface "),
		i(1, "ComponentName"),
		t({ "Props {", "\t" }),
		i(2, "// props"),
		t({ "", "}", "", "const " }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t(": React.FC<"),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t({ "Props> = (props) => {", "\treturn (", "\t\t" }),
		i(3, "<div></div>"),
		t({ "", "\t);", "};" }),
	}),

	-- Hooks and other snippets
	s("us", {
		t("const ["),
		i(1, "state"),
		t(", set"),
		i(2, "State"),
		t("] = useState("),
		i(3, "initialValue"),
		t(");"),
	}),
	s("ue", {
		t({ "useEffect(() => {", "\t" }),
		i(1, "// effect"),
		t({ "", "}, [" }),
		i(2, "dependencies"),
		t("]);"),
	}),
	s("try", {
		t({ "try {", "\t" }),
		i(1, "// try body"),
		t({ "", "} catch (error) {", "\t" }),
		i(2, "console.error(error);"),
		t({ "", "}" }),
	}),
	s("filter", {
		i(1, "array"),
		t(".filter(("),
		i(2, "item"),
		t(") => "),
		i(3, "condition"),
		t(")"),
	}),
	s("afa", {
		t("const "),
		i(1, "name"),
		t(" = async ("),
		i(2, "args"),
		t({ ") => {", "\t" }),
		i(3, "// body"),
		t({ "", "};" }),
	}),
})

-- JSX snippets
ls.add_snippets("javascriptreact", {
	s("rfc", {
		t("function "),
		i(1, "ComponentName"),
		t({ "(props) {", "\treturn (", "\t\t" }),
		i(2, "<div></div>"),
		t({ "", "\t);", "}" }),
	}),
	s("rafc", {
		t("const "),
		i(1, "ComponentName"),
		t({ " = (props) => {", "\treturn (", "\t\t" }),
		i(2, "<div></div>"),
		t({ "", "\t);", "};" }),
	}),
})

-- TSX snippets
ls.add_snippets("typescriptreact", {
	s("rfc", {
		t("interface "),
		i(1, "ComponentName"),
		t({ "Props {", "\t" }),
		i(2, "// props"),
		t({ "", "}", "", "function " }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t("(props: "),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t({ "Props) {", "\treturn (", "\t\t" }),
		i(3, "<div></div>"),
		t({ "", "\t);", "}" }),
	}),
})
