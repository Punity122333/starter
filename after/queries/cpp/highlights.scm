;; extends
"[" @bracket.square
"]" @bracket.square
"(" @bracket.paren
")" @bracket.paren
"{" @bracket.curly
"}" @bracket.curly
"mutable" @mutable
;; iostream stuff
((identifier) @io.cout (#eq? @io.cout "cout"))
((identifier) @io.cin (#eq? @io.cin "cin"))
((identifier) @io.endl (#eq? @io.endl "endl"))
