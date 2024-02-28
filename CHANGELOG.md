## 0.2.1

- Fork from [equatable_lint](https://pub.dev/packages/equatable_lint)

- Available lints :
    - Lint when a field is missing in equatable props => "missing_field_in_equatable_props"
    - Lint when a class extending an Equatable class does not call super when overriding equatable props => "always_call_super_props_when_overriding_equatable_props"

- Available fixes for the lints :
    - "missing_field_in_equatable_props" :
        - A quick fix to add every fields to the equatable props
        - A quick fix to create the equatable props with every fields in it
        - A quick fix to add a specific field to the equatable props
        - A quick fix to create the equatable props with a specific in it
    - "always_call_super_props_when_overriding_equatable_props" :
        - A quick fix to call super in overridden equatable props