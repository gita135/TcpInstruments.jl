import DocStringExtensions
import DocStringExtensions: SIGNATURES, TYPEDSIGNATURES, DOCSTRING,
    FIELDS, TYPEDFIELDS,EXPORTS

DocStringExtensions.@template (FUNCTIONS, METHODS, MACROS) =
    """
    $(TYPEDSIGNATURES)

    $(DOCSTRING)
    """

DocStringExtensions.@template TYPES =
    """
    Fields:
    $(TYPEDFIELDS)

    ---

    $(DOCSTRING)

    ~~~~~~~~
    $(EXPORTS)
    """