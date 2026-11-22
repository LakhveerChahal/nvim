; extends

; Highlight a Python string as SQL when the line directly above it is exactly `# sql`
;   # sql
;   MY_QUERY = """SELECT ..."""
((comment) @_marker
 .
 (expression_statement
   (assignment
     right: (string (string_content) @injection.content)))
 (#match? @_marker "^#\\s*sql\\s*$")
 (#set! injection.language "sql"))
