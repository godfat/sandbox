# -*- coding: utf-8 -*-
"""
    pygments.styles.twilight
    ~~~~~~~~~~~~~~~~~~~~~~~~

    inspired by TextMate
"""

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Number, Operator, Generic, Whitespace, Punctuation


class TwilightStyle(Style):
    """
    inspired by TextMate
    """

    background_color = "#000000"
    highlight_color = ""
    default_style = ""

    styles = {
        Whitespace:                "#000000",
        Comment:                   "#5F5A60",
        Comment.Preproc:           "",
        Comment.Special:           "",

        Keyword:                   "#CDA869",
        Keyword.Declaration:       "",
        Keyword.Namespace:         "",
        Keyword.Pseudo:            "#CDA869",
        Keyword.Type:              "#9B859D",

        Operator:                  "#CDA869",
        Operator.Word:             "",

        Punctuation:               "#CDA869",

        Name:                      "#FFFFFF",
        Name.Builtin:              "#7587A6",
        Name.Function:             "#9B703F",
        Name.Class:                "#9B859D",
        Name.Namespace:            "",
        Name.Exception:            "",
        Name.Variable:             "",
        Name.Variable.Instance:    "",
        Name.Variable.Class:       "",
        Name.Variable.Global:      "",
        Name.Constant:             "#9B859D",
        Name.Label:                "",
        Name.Entity:               "",
        Name.Attribute:            "",
        Name.Tag:                  "",
        Name.Decorator:            "",

        String:                    "#8F9D6A",
        String.Char:               "",
        String.Doc:                "",
        String.Interpol:           "",
        String.Escape:             "",
        String.Regex:              "#E9C062",
        String.Symbol:             "#CF6A4C",
        String.Other:              "#FFFFFF",

        Number:                    "#CF6A4C",
        Number.Integer:            "",
        Number.Float:              "",
        Number.Hex:                "",
        Number.Oct:                "",

        Generic.Heading:           "",
        Generic.Subheading:        "",
        Generic.Deleted:           "",
        Generic.Inserted:          "",
        Generic.Error:             "",
        Generic.Emph:              "",
        Generic.Strong:            "",
        Generic.Prompt:            "",
        Generic.Output:            "",
        Generic.Traceback:         "",

        Error:                     ""
    }
