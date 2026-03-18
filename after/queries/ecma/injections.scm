; extends

; 1. Fix for tagged templates: css` ... `
(
  (identifier) @tag
  (#eq? @tag "css")
  (template_string) @injection.content
  (#set! injection.language "css")
)

; 2. Fix for magic comments: /* css */ ` ... `
(
  (comment) @injection.language
  (#lua-match? @injection.language "/%*%s*css%s*%*/")
  .
  (template_string) @injection.content
  (#set! injection.language "css")
)

; 3. Keep your existing HTML tag logic if you want
(
  (identifier) @tag
  (#eq? @tag "html")
  (template_string) @injection.content
  (#set! injection.language "html")
)
