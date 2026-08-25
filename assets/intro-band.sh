#!/bin/bash
# das-auto — ignition sequence, played on the prompt box rules.
#
# The two ─ rules that sandwich the input are the only thing touched. DAS
# rides in along the top rule from the left, AUTO along the bottom rule from
# the right, a glimmer travels down both, then the orange fades back to the
# terminal's normal rule grey and Claude repaints its own box.
#
# The rules are FOUND, not hardcoded: the prompt box grows as the user types,
# so their rows move. Their real positions come from the screen contents.
#
# Two things keep it from tearing:
#   * every frame is one string written with ONE printf — per-cell writes
#     race Claude's repaint and flicker badly
#   * frames are wrapped in synchronized output (DEC 2026), so the terminal
#     shows only completed frames

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SND="$DIR/dasauto.wav"

play_sound() {
  [ -f "$SND" ] || return 0
  for p in pw-play paplay aplay; do
    command -v "$p" >/dev/null 2>&1 && { "$p" "$SND" >/dev/null 2>&1 & return 0; }
  done
}

# Where to draw, and whether we may. probe.py handles the terminal-specific
# part: kitty and tmux can both be asked to read their own screen, anything
# else cannot, and painting rows we never read is not something to do to
# somebody's terminal uninvited.
command -v python3 >/dev/null 2>&1 || { play_sound; exit 0; }
eval "$(python3 "$DIR/probe.py" 2>/dev/null)"

case "${MODE:-sound}" in
  kitty|tmux|blind) : ;;
  *) play_sound; exit 0 ;;
esac
[ -n "$TTY" ] && [ -w "$TTY" ] || { play_sound; exit 0; }
[ -n "$RULE_TOP" ] && [ -n "$RULE_BOT" ] || { play_sound; exit 0; }

exec 3>"$TTY" || { play_sound; exit 0; }

ORANGE="255;135;0"
RULE_RGB="136;136;136"

# Foreground escape for a colour spec: "R;G;B", a 256 index, or "def".
fg() {
  case "$1" in
    def)   printf '\033[39m' ;;
    *\;*)  printf '\033[38;2;%sm' "$1" ;;
    *)     printf '\033[38;5;%sm' "$1" ;;
  esac
}
# Glimmer cross-section: dim shoulders, single white peak.
GPROFILE=(214 220 228 231 228 220 214)

restore() {
  printf '\0338\033[?25h\033[0m' >&3
  # Make the TUI repaint from its own model. SIGWINCH to the process that
  # owns this pts works on any terminal; the kitty resize is a belt-and-
  # braces nudge where it happens to be available.
  [ -n "$PID" ] && kill -WINCH "$PID" 2>/dev/null
  if [ "$MODE" = "kitty" ] && [ -n "$KITTY_LISTEN_ON" ]; then
    kitten @ --to "$KITTY_LISTEN_ON" resize-window --increment 1  >/dev/null 2>&1
    kitten @ --to "$KITTY_LISTEN_ON" resize-window --increment -1 >/dev/null 2>&1
  fi
  exec 3>&-
}
trap restore EXIT INT TERM

play_sound() {
  [ -f "$SND" ] || return 0
  for p in pw-play paplay aplay; do
    command -v "$p" >/dev/null 2>&1 && { "$p" "$SND" >/dev/null 2>&1 & return 0; }
  done
}

RULE=$(printf '─%.0s' $(seq 1 "$COLS"))
BEGIN='\033[?2026h'; END='\033[?2026l'

DAS=" D A S "
AUTO=" A U T O "

# One rule row: base colour, an optional glimmer run, an optional word
# spliced in so it reads as part of the line rather than sitting on top.
rule_row() {
  local row="$1" word="$2" wx="$3" gl="$4" base="$5" wcol="${6:-255;255;255}"
  local out="\033[${row};1H"
  out+="$(fg "$base")"

  if [ -n "$gl" ] && (( gl > -${#GPROFILE[@]} && gl < COLS+${#GPROFILE[@]} )); then
    # Falloff either side of a single white column — a flat bright run reads
    # as a moving block, a gradient reads as light travelling along the rule.
    local i col pre=$(( gl - 1 ))
    (( pre < 0 )) && pre=0
    (( pre > COLS )) && pre=COLS
    out+="${RULE:0:$pre}"
    for (( i=0; i<${#GPROFILE[@]}; i++ )); do
      col=$(( gl + i ))
      (( col < 1 || col > COLS )) && continue
      out+="\033[38;5;${GPROFILE[$i]}m─"
    done
    local after=$(( gl + ${#GPROFILE[@]} ))
    (( after < 1 )) && after=1
    local post=$(( COLS - after + 1 ))
    (( post < 0 )) && post=0
    out+="$(fg "$base")${RULE:0:$post}"
  else
    out+="${RULE}"
  fi

  if [ -n "$word" ]; then
    local w="$word" c="$wx"
    if (( c < 1 )); then w="${w:$((1-c))}"; c=1; fi
    (( c <= COLS )) && {
      (( c + ${#w} - 1 > COLS )) && w="${w:0:$((COLS-c+1))}"
      [ -n "$w" ] && out+="\033[${row};${c}H\033[1m$(fg "$wcol")${w}"
    }
  fi
  printf '%s' "$out\033[0m"
}

# Every frame ends by re-hiding the cursor and returning it to the position
# Claude left it in (DECRC). Without this the cursor is parked wherever the
# last write landed — right after AUTO — and Claude's next repaint shows it
# blinking there.
frame() {  # das_x auto_x glimmer base [word_colour]
  printf '%b' "$BEGIN\033[?25l$(rule_row "$RULE_TOP" "$DAS" "$1" "$3" "$4" "$5")$(rule_row "$RULE_BOT" "$AUTO" "$2" "$3" "$4" "$5")\0338\033[?25l$END" >&3
}

# Motion at constant velocity reads as mechanical. Positions are eased:
# words decelerate into their marks (cubic ease-out, the shape of something
# with mass coming to rest) and the glimmer accelerates through the middle
# and eases out either end (cubic ease-in-out).
ease_out() {   # start end frames
  awk -v a="$1" -v b="$2" -v n="$3" 'BEGIN{
    for(i=1;i<=n;i++){t=i/n; e=1-(1-t)^3; printf "%d\n", int(a+(b-a)*e+0.5)}}'
}
ease_in_out() { # start end frames
  awk -v a="$1" -v b="$2" -v n="$3" 'BEGIN{
    for(i=1;i<=n;i++){t=i/n;
      e = (t<0.5) ? 4*t*t*t : 1-((-2*t+2)^3)/2
      printf "%d\n", int(a+(b-a)*e+0.5)}}'
}

printf '\0337\033[?25l' >&3

DAS_MARK=$(( (COLS - ${#DAS}) / 2 ))
AUTO_MARK=$(( DAS_MARK - 1 ))

# Pace the whole sequence off the jingle actually installed. install-sound.sh
# caches its duration; a longer clip stretches the dwells rather than leaving
# the animation finishing while the voice is still talking.
DUR=$(cat "$DIR/dasauto.dur" 2>/dev/null || echo 1.24)
SCALE=$(awk -v d="$DUR" 'BEGIN{s=d/1.24; if(s<0.6)s=0.6; if(s>3)s=3; printf "%.3f", s}')
dwell() { awk -v b="$1" -v s="$SCALE" 'BEGIN{printf "%.4f", b*s}'; }
SLIDE_T=$(dwell 0.014); GLIM_T=$(dwell 0.013); FADE_T=$(dwell 0.032); HOLD_T=$(dwell 0.30)

play_sound

# DAS rides in from the left along the top rule.
while read -r x; do
  frame "$x" $(( COLS + 2 )) "" "$ORANGE"; sleep "$SLIDE_T"
done < <(ease_out $(( -${#DAS} )) "$DAS_MARK" 24)

# AUTO rides in from the right along the bottom rule.
while read -r x; do
  frame "$DAS_MARK" "$x" "" "$ORANGE"; sleep "$SLIDE_T"
done < <(ease_out "$COLS" "$AUTO_MARK" 24)

# Glimmer travels down both rules.
while read -r g; do
  frame "$DAS_MARK" "$AUTO_MARK" "$g" "$ORANGE"; sleep "$GLIM_T"
done < <(ease_in_out -8 $(( COLS + 8 )) 46)

frame "$DAS_MARK" "$AUTO_MARK" "" "$ORANGE"
sleep "$HOLD_T"

# Exit: the orange cools to #888888 — the colour Claude actually draws these
# rules in — while the words ride back out the way they came. Both curves run
# together so nothing snaps: earlier versions dropped the letters in a single
# frame while the rules eased, and the mismatch broke the illusion.
while read -r r g b dx ax; do
  frame "$dx" "$ax" "" "${r};${g};${b}" "${r};${g};${b}"; sleep "$FADE_T"
done < <(awk -v dm="$DAS_MARK" -v am="$AUTO_MARK" -v cols="$COLS" -v dl="${#DAS}" -v al="${#AUTO}" 'BEGIN{
  n=18
  for(i=1;i<=n;i++){
    t=i/n
    ec = 1-(1-t)^3        # colour settles
    ep = t*t*t            # words accelerate away, each continuing the way it
                          # was already travelling rather than reversing
    printf "%d %d %d %d %d\n",
      255+(136-255)*ec, 135+(136-135)*ec, 0+(136-0)*ec,
      dm+((cols+2)-dm)*ep, am+((-al)-am)*ep }}')
# End on the rules' real colour, never on "def": the terminal's default
# foreground is white here, and Claude does not repaint these rows after the
# resize — so the last thing painted is the colour that stays.
for c in "$RULE_RGB" "$RULE_RGB" "$RULE_RGB"; do
  printf '%b' "$BEGIN\033[?25l$(rule_row "$RULE_TOP" "" 0 "" "$c")$(rule_row "$RULE_BOT" "" 0 "" "$c")\0338\033[?25l$END" >&3
  sleep 0.05
done

exit 0
