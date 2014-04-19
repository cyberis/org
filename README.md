# Orgmode For Atom.io

This is an attempt to bring org-mode to the atom editor.

To learn more about org-mode, go here: http://orgmode.org

The package is activated by pressing ctrl-alt o. After that, every file with an .org extension will be in "org-mode".

You probably don't want to use this yet, but you are very welcome to contribute.

My first goal is implement [structure editing](http://orgmode.org/manual/Structure-editing.html).

## Functionality so far

Files with .org extension are in "org-mode", providing the following:
* Insert empty headline with Cmd-Enter
* Insert TODO headline with Shift-Cmd-Enter
* Demote (shift right) headline with Alt-Right
* Promote (shit left) headline with Alt-Left
* Insert break on the fly when typing a '*'
* TODO keyword is colored in red
* Rudimentary state cycling TODO -> NEXT -> DONE with Shift-Right/Shift-Left 
## Roadmap

* Structure editing
* Custom TODO keywords
* Basic Agenda views
* Customization
* Capturing
* Advanced agenda views
* Whatever else has been added to the original in 11 years of development :)
