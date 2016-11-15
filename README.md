## EteSkeleton
This is a mirror of http://www.vim.org/scripts/script.php?script\_id=3370

A simple plugins that would help to manage skeletons(templates) for automate
the creation of new files and insert tags (user definable) like *user* , *date*,
*askversion*  and so on.

It let you to use different *skeletons* for the same *filetype*, depending on
the filename.

#### Skeletons
You can name skeletons in tree ways:

* filetype
* name_filetype                 (must enable g:EteSkeleton_loosefiletype)
* dot.separated.keys.filetype   (must enable g:EteSkeleton_loosefiletype_enhanced)

##### Create skeleton is easy.

Just create an empty file,
```vim
:tabnew
```
Edit your skeleton and save it using
```vim
:EteSkelMake filetype || name_filetype || dot.separated.keys.filetype
```

#### Tags
Every skeleton can contains `tags` which will be converted on the fly when
*eteSkeleton* loads the skeleton and are defined in the
`/skeleton/tags/eteSkeleton.tags` file.

*eteSkeleton* comes with few predefined tags:

* ask: Prompts the user for a value. 
* askversion: Prompts the version value.
* author: changed with the $USER.
* basename: filename without path and extension.
* date: current date in dd/mm/yyyy format.
* filename: current filename.
* home: user home directory. 
* parentname: name of the parent folder (no path).
* timestamp: date in yyyy-mm-dd format.
* title: Capitalized filename without path or extension.
* titlemark: `g:eteSkeleton_titlemark_char` repeated for the title length.
* version: starting version (0.0.1).
* wholetitle: like *title* but with some restructuredtext sphinx flavour for python module.
* wholetitlemark: like *titlemark* but based on *wholetitle*.

#### User defined.
There is three ways to define a *tag* 

###### Edit the `eteSkeleton.tags`.
Simply edit the file and add your tag an assignment.
```vim
mypath=expand("%:p:h")
```
###### Using the `EteSkelAdd` command.
```vim
:EteSkelAdd mypath=expand("%:p:h")
```
If you omit the assignment (=expand("%:p:h") part in this case) `EteSkelAdd'
will prompt you for the value.

###### Using the `<Leader>st` (`EteSkelAddTag` command).
Just positioning you cursor over the tag name and type `<Leader>st` and 
`EteSkelAddTag` will prompt you for the value.


## Installation

If you don't have a preferred installation method, one option is to install
[pathogen.vim](https://github.com/tpope/vim-pathogen), and then copy
and paste:

    cd ~/.vim/bundle
    git clone https://github.com/ellethee/eteSkeleton.git
    vim -u NONE -c "helptags eteSkeleton/doc" -c q
    
Or using [Vundle.vim](https://github.com/VundleVim/Vundle.vim) adding to your `.vimrc` the line 
	
    Plugin "ellethee/eteSkeleton"

### Examples

(with g:EteSkeleton\_loosefiletype\_enanched = 1)
```vim
:tabnew module.py
```
```python
# -*- coding: utf-8 -*-
"""
{wholetitlemark}
{wholetitle}
{wholetitlemark}
Module description here
"""
```
```vim
:EteSkelMake  "Will create a module.python skeleton
```
```vim
:tabnew run.py
```
```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
{wholetitlemark}
{wholetitle}
{wholetitlemark}
Script description here
"""
import yaml
from argparseinator import ArgParseInator

__version__ = "{version}"

def cfg_factory(filename):
    """Cfg factory"""
    try:
        with open(filename, 'rb') as stream:
            return yaml.load(stream)
    except: 
        return {}
import .<commands>

if __name__ == "__main__":
    ArgParseInator(auto_exit=True, config=(None, cfg_factory)).check_commad()
```
```vim
:EteSkelMake	"Will create a run.python skeleton
```

```vim
:tabnew test.run.py
```
Creates a new file called test.py based on the run.python skeleton and loosing the **run** part.


You can use more complex names.

```vim
:tabnew django.models.py
```
```python
# -*- coding: utf-8 -*-
"""
{wholetitlemark}
{wholetitle}
{wholetitlemark}
Django modules for {parentname}
"""
from django.db import models
```
```vim
:EteSkelMake 	"Will create a django.models.python skeleton
```
```vim
:tabnew polls/models.django.models.py
```
Will creates a models.py file in based upon the django.models.python skeleton loosing the **django.models** part.




