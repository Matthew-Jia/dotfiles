# Important/Basic 
important/basic: j, k, h, l -> down, up, left, right
important/basic: jk -> escape
important/basic: i -> insert
important/basic: a -> append
important/basic: : -> command
important/basic: V -> v-line (start high-lighting) 

# Movement 

>> Moving Horizontally
horizontal movement: w -> move forward a word (considers punctuation as seperate words)
horizontal movement: W -> move forwards a word (punctuation ignored)
horizontal movement: b -> move backwards a word (considers puctuation as seperate words)
horizontal movement: B -> move backwards a word (punctuation ignored)
horizontal movement: e -> move to end of a word (considers punctuation as seperate words)
horizontal movement: E -> move to end of a word (considers punctuation as seperate words)

>> Moving Vertically
horizontal movement: gg -> move to the top/beginning of a file
horizontal movement: G -> move to the bottom/end of a file
horizontal movement: Ctrl + e -> move the screen down without moving the cursor
horizontal movement: Ctrl + y -> move the screen up without moving the cursor
horizontal movement: Ctrl + f -> move forward/down one entire screen
horizontal movement: Ctrl + b -> move backward/up one entire screen
horizontal movement: Ctrl + d -> move forward/down half screen
horizontal movement: Ctrl + u -> move backwards/up half screen
horizontal movement: gd -> move to the local declaration of any code
horizontal movement: gD -> move to the global declaration of any code
horizontal movement: % -> move between pairs of (), {}, [] or any other type of such braces
horizontal movement: { -> move to the next paragraph/ code block/ function/ etc.
horizontal movement: } -> move to the previous paragraph/ code block/ fucntion/ etc.
horizontal movement: fa -> move to the next occurence of the character 'a' in a sentence
horizontal movement: Fa -> move to the previous occurence of the character 'a' in a sentence
horizontal movement: ta -> jump to before of the next occurence of the character 'a' in a sentence
horizontal movement: Ta -> jump to after of the previous occurence of the character 'a' in a sentence

>> Search and navigation
search and navigation: * -> next occurence of the word under the cursor
search and navigation: \# -> previous occurence of the word under the cursor
search and navigation: n -> next occurence of the word searched pattern
search and navigation: N -> previous occurence of the word search pattern

>> Moving across files
moving across files: Ctrl + O -> move in the previously opened file
moving across files: Ctrl + I move in the next file
moving across files: Ctrl + ^ -> move the previous two opened files
moving across files: :bn -> move into the next buffer
moving across files: :bp -> move to the previous buffer
moving across files: :b filename -> move from a buffer using a filename
moving across files: :bindex -> move from a buffer using an index
moving across files: :e filename -> start editing filename

>> Moving between tabs
moving between tabs: :tabnew filename -> create a tab of a file
moving between tabs: gt -> move to the next tab
moving between tabs: ngt -> move to the nth tab
moving between tabs: gT -> move to the previous tab
moving between tabs: :tabo -> close all the tabs except the current one
moving between tabs: :tabc -> close the tab 
moving between tabs: :tabm n -> move the current tab to nth position

>> Movement in Marks
movement in marks: mn -> set the current position as mark 'n'
movement in marks: <backtick>n -> jump to the position of mark 'n'

# Split Windows

>> Creating Split Windows
creating split windows: :vs -> create a vertical split 
creating split windows: :sv -> create a horizontal split 

>> Split Windows Movement 
split windows movement: Ctrl + w + h -> jump to the left split
split windows movement: Ctrl + w + j -> jump to the split down
split windows movement: Ctrl + w + k -> jump to the upper split
split windows movement: Ctrl + w + l -> jump to the left split

>> Split Windows Control
split windows control: Ctrl + w + r -> move the split down
split windows control: Ctrl + w + R -> move the split up

# Text Editing
text editing: y -> copy selected region
text editing: CMD + v -> paste
text editing: u -> undo
text editing: Ctrl + r -> redo
text editing: :%s/old/new/g -> replaces all occurences of 'old' with 'new' in the entire file
text editing: Ctrl + & -> comment out sections
text editing: Ctrl + v -> bypass neovim plugins for the next keystroke (most important for bypassing auto-pairs)

# nvim-surround

## Note: use the open version ({) to add spaces (text -> { text }) and the closed version (}) to not add spaces (text -> {text})

## Normal mode
ys{motion}{char} -> add surround
	- ysiw" -> surround inner word with quotes
	- ys$) -> surround the rest of the line with quotes
cs{old}{new} -> change surround
  - cs"' -> "word" -> 'word'
  - cs)] -> (word) -> [word]
ds{char} -> delete surround
  - ds" -> "word" -> word
  - ds) -> (word) -> word

## Visual mode
S{char} -> surround selection
  - select word, then S" -> "word"
  - select phrase, then S) -> (phrase)

## Insert mode
<C-g>s{char} → surround word before cursor
  - type word, then <C-g>s" → "word"
<C-g>S{char} → surround entire line
  - <C-g>S) → (whole line)

# markdown
zR -> open all folds
zM -> close all folds
za -> toggle under current fold
zA -> toggle all folds under current fold

# Program Development
:make -> make the program at the location that nvim was opened
:cnext -> go to the next compilation error
:cprev -> go to the previous compilation error
:copen -> go to the list of compilation errors
