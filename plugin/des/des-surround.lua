local noremap = require("lib.map").noremap

noremap("n", "ys", [["v" . input("Where: ") . "\"sc" . input("Add what: ") . "<c-o>h<c-r>s<esc>"]], { expr=true })
noremap("n", "cs", [["vi" . input("Change what: ") . "\"sc<c-o>l<c-h><c-h>" . input("To what: ") . "<c-o>h<c-r>s<esc>"]], { expr=true })
