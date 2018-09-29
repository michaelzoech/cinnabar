# Cinnabar

Enhance your Mercurial command-line experience with this set of aliases and scripts.
The idea behind this project is based on [SCM Breeze][1] which is available for Git.
Cinnabar provides the following features:

* Aliases for Mercurial commands
* Numbered file shortcuts

## Installation

1. Clone this repository
2. Source `cinnabar.sh` from your `.bashrc` or `.zshrc` file.

## Usage

Whenever you view your Mercurial repo status, each path gets assigned to an environment variable.
Use `hs` to view the enhanced `hg status` output.
The files are numbered from 1,2,... and stored in the environment variables `CINFILE1`,`CINFILE2`,... .

The numbers can be used with shortcuts such as `ha` (`hg add`).
Only the number has to be specified instead of typing the full file path.
Number ranges can be used to reference a range of files.

The following shortcuts support numbered files and numbered ranges:

* `ha`: `hg add`
* `hc`: `hg commit`
* `hd`: `hg diff`
* `hl`: `hg log`
* `hrm`: `hg remove`
* `hre`: `hg revert`
* `rm`: `rm`

## License

    Copyright (c) 2018 Michael Zoech

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
