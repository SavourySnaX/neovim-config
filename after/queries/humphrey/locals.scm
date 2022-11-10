
; Functions

(function_definition
 (identifier_list
  (identifier)+ @definition.function))

; Parameters

(input_parameters
 (type_definition
  (identifier_list
   (identifier)+ @definition.parameter)))

(output_parameters
 (type_definition
  (identifier_list
   (identifier)+ @definition.parameter)))

; Variables

(variable_definition
 (identifier_list
  (identifier)+ @definition.var))

; Scope

(block) @scope
