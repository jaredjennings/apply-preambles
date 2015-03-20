apply-preambles
---------------

So you have a whole tree of files and directories. The files contain
source code of varying types: some LaTeX, some Puppet, some Python,
some bash, etc. You need to write something at the top of each
file. Perhaps you need to indicate under what terms the file may be
used, or make the file indicate that it came from a particular
collection. `apply-preambles` does this.

For example, say you have a directory called ``myproject``. It
contains ``file1.tex`` and ``file2.py``. You write a text file named
``pipewarning``, containing the text "This is not a pipe." Then::

  preamble apply pipewarning .

Now the top of file1.tex will say ::

  % --- BEGIN pipewarning ---
  % This is not a pipe.
  % --- END pipewarning ---

And (let us imagine that file2.py has a shebang at the top,
``#!/usr/bin/env python``) the top of file2.py will say ::

  #!/usr/bin/env python
  # --- BEGIN pipewarning ---
  # This is not a pipe.
  # --- END pipewarning ---

As shown above, the lines added will be commented properly given the
apparent syntax of the file, as judged by the file's pathname and
extension. The list of syntaxes supported is in the script.

To run tests, ``bash tests.sh``.

``apply-preambles`` is made available to you under the terms of the
GNU General Public License, version 3 or later. ``apply-preambles`` is
based on <https://github.com/afseo/cmits>.
