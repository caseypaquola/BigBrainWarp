# -*- coding: utf-8 -*-
from distutils.core import setup
import sys

_version = '2020.07.8.2'
_packages = ['style']

_short_description = "enigma-pygments-style is a modern style based on the VIM pyte theme."


_install_requires = [
    'pygments>=2'
]

setup(
    name='enigma-pygments-style',
    url='https://github.com/saratheriver/enigma-pygments-style',
    author='Sara Lariviere',
    author_email='saratheriver@gmail.com',
    description=_short_description,
    version=_version,
    packages=_packages,
    install_requires=_install_requires,
    license='BSD',
    keywords='pygments syntax highlighting',
    entry_points={
        'pygments.styles': [
            'enigmalexer = style:EnigmaLexerStyle',
        ]
    }
)
