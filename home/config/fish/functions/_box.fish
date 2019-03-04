function _box
  set border_h ─ ━ ═ ─
  set border_v │ ┃ ║ ║
  set corner_tl ╭ ┏ ╔ ╓
  set corner_bl ╰ ┗ ╚ ╙
  set corner_tr ╮ ┓ ╗ ╖
  set corner_br ╯ ┛ ╝ ╜
  
  set box_part $argv[1];
  set index $argv[2];

  switch $box_part
  case h; printf $border_h[$index]
  case v; printf $border_v[$index]
  case tl; printf $corner_tl[$index]
  case bl; printf $corner_bl[$index]
  case tr; printf $corner_tr[$index]
  case br; printf $cornerbr[$index]
  end
end
