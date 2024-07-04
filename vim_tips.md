<h1>Tips to navigate Vi</h1>

In the KodeKloud lab environment you are required to use the **Vi** editor. Below are some useful commands to help you complete the exercises.

<h2>grep</h2>

**`grep`**, which is short for "Global Regular Expression Print" is a command-line utility in Unix and Unix-like operating systems that searches for patterns in text files. 

It is primarily used to search for lines matching a specified pattern within one or more files using regular expressions. It has powerful searching capabilities.

`grep` can be used to quickly locate specific information within YAML configuration files:

1. Searching for specific strings or patterns within files.
2. Filtering and extracting lines from files based on certain criteria.
3. Counting occurrences of a pattern in a file.
4. Recursive searching within directories and subdirectories.
5. Combining with other commands through pipes to perform complex text processing tasks.

To search for the specified "search_string" within the "filename.yaml" file:
* `grep -n "search_string" filename.yaml`

To perform a case-insensitive search for the specified "search_string" within the "filename.yaml" file:
* `grep -i "search_string" filename.yaml`

An example of it’s usage in Kubernetes to find the docker image used:
* `kubectl describe pod my-pod | grep -i image`

<h2>Vim</h2>

Change in each session by pressing escape and using the commands below

* Go to the top of the file with `gg`
* Go to the bottom of the file with `G`
* Go to line 25 with `25G`
* Save your changes `:w`
* Exit the changed buffer without saving any changes with :q!

Setting up vim ~/.vimrc or change in each session by pressing escape and using the commands below

* Set line numbers with `:set number`
* To undo use `:set nonumber`

<h3>Searching in text</h3>

Searching is a fundamental feature of Vim and is essential for navigating and editing files efficiently. Here are some basic steps for searching in Vim. 

In Vim, you can search for text using the `/` or `?` commands. Precede by pressing escape to go into command mode. 

**Forward Search (`/`)**
To search for the word "example", you would type `/example` and press Enter.

**Backward Search (`?`)**
* To search backward for the word "example", you would type `?example` and press Enter.

**Navigate through the search results**
* `n` Move to the next occurrence of the pattern
* `N` Move to the previous occurrence of the pattern.

Search Options can be done with case sensitivity and whole word matching.
* `:set ignorecase` Ignore case when searching.
* `:set smartcase` Override ignorecase if the search pattern contains uppercase characters.
* `:set hlsearch` Highlight search results.
* `:set incsearch`  Incremental search, highlights matches as you type the search pattern

**Clearing Search Highlighting**
* `:nohlsearch` To clear search highlighting of search results

**Search and Replace**

Use the `:%s` command followed by the search pattern, replacement pattern, and optional flags. Here to replace old_text with new_text in the first occurrence or add the flag g to search globally (the entire document)
* `:%s/old_text/new_text`
* `:%s/old_text/new_text/g` 

Case Insensitive Search and Replace by adding the i flag
* `:%s/pattern/replacement/gi`

Confirmation Before Replace using the `c` flag to prompt for confirmation before each replacement
* `:%s/pattern/replacement/gc`

You can set these options temporarily by typing esc, then colon (`:`) followed by the command, or you can add them to your .vimrc file for permanent settings.

