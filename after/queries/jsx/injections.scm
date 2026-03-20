; extends

; Magic comment: /* css */` ... `
(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*css%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

; Tagged template: css` ... `
(call_expression
  function: (identifier) @_tag
  (#eq? @_tag "css")
  arguments: (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

; styled.div` ... ` etc
(call_expression
  function: (member_expression
    object: (identifier) @_tag
    (#eq? @_tag "styled"))
  arguments: (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

; styled(Component)` ... `
(call_expression
  function: (call_expression
    function: (identifier) @_tag
    (#eq? @_tag "styled"))
  arguments: (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

; Magic comment: /* html */` ... `
(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*html%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "html")
  (#set! injection.include-children true)
)

; Tagged template: html` ... `
(call_expression
  function: (identifier) @_tag
  (#eq? @_tag "html")
  arguments: (template_string) @injection.content
  (#set! injection.language "html")
  (#set! injection.include-children true)
)

; Magic comment: /* sql */` ... `
(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*sql%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "sql")
  (#set! injection.include-children true)
)

; Tagged template: sql` ... ` / SQL` ... `
(call_expression
  function: (identifier) @_tag
  (#any-of? @_tag "sql" "SQL" "gql" "graphql")
  arguments: (template_string) @injection.content
  (#set! injection.language "graphql")
  (#set! injection.include-children true)
)

; Magic comment: /* graphql */` ... `
(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*graphql%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "graphql")
  (#set! injection.include-children true)
)
