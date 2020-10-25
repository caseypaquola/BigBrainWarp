# ENIGMA Pygments Style

Enable a style in Pygments Python package for highlighting customized 'friendly' code. Notably, this can be coupled with Sphinx Python documentation generator. 

Install
-----------

`python -m pip install enigma-pygments-style`

Verify it is working
---------------------

Please run the following commands in the Python Interpreter:

``` python
    >>> from pygments.styles import get_all_styles
    >>> list(get_all_styles())
```

And verify that you have a new Pygments style named `enigmalexer`

Using it in your Sphinx latex output
--------------------------------------

To use this freshly installed Pygment style, you finally need to add the following line to your conf.py file:

``` python
# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'enigmalexer'

```

Modifying style rules
----------------------

To modify it, please take a look at the file [enigmalexer.py](https://github.com/saratheriver/enigma-pygments-style/tree/master/style)
