(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*css%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

(call_expression
  function: (identifier) @_tag
  (#eq? @_tag "css")
  arguments: (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

(call_expression
  function: (member_expression
    object: (identifier) @_tag
    (#eq? @_tag "styled"))
  arguments: (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

(call_expression
  function: (call_expression
    function: (identifier) @_tag
    (#eq? @_tag "styled"))
  arguments: (template_string) @injection.content
  (#set! injection.language "scss")
  (#set! injection.include-children true)
)

(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*html%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "html")
  (#set! injection.include-children true)
)

(call_expression
  function: (identifier) @_tag
  (#eq? @_tag "html")
  arguments: (template_string) @injection.content
  (#set! injection.language "html")
  (#set! injecton.include-children true)
)

(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*sql%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "sql")
  (#set! injection.include-children true)
)

(call_expression
  function: (identifier) @_tag
  (#any-of? @_tag "sql" "SQL" "gql" "graphql")
  arguments: (template_string) @injection.content
  (#set! injection.language "graphql")
  (#set! injection.include-children true)
)

(
  (comment) @_comment
  (#lua-match? @_comment "/%*%s*graphql%s*%*/")
  (template_string) @injection.content
  (#set! injection.language "graphql")
  (#set! injection.include-children true)
)
