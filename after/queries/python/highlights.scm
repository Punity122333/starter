;; extends
"[" @bracket.square
"]" @bracket.square
"(" @bracket.paren
")" @bracket.paren
"{" @bracket.curly
"}" @bracket.curly

((comment) @comment
 (#set! priority 110))
