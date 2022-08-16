import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.variant;

class Arcway_State {
  Variant[string] k;
}

Arcway_State arcway_init() {
  return new Arcway_State();
}

Variant[string] arc_get_data(Arcway_State arc) {
  return arc.k;
}

Variant aw_get_value(Arcway_State s, 
    string n) 
{
  return s.k[n];
}

Variant resolve_Type(string s) {
  /* bjorn wouldnt be proud of me :( */
  try {
    Variant fi = to!bool(s);
    return fi;
  } catch (ConvException) {} // 1st try
  try {
    Variant fin = to!float(s);
    return fin;
  } catch (ConvException) { /* return the string itself (unknown type) */
    return Variant(s);
  }
  // return Variant(null);
}

void arc_to_top(Arcway_State x,
                string code) {
  string b;
  int s = 0;
  string n;
  string l;

  /* opt: arrays */
  Variant[] g;
  int count = 0;
  foreach (char lf 
      ; code) {
    switch (lf) {
      case ':': /* variable notice */
        if (s==0){
          n=b;
          s = 1; /* we're collecting now */
          b = ""; /* ditch old buffer */
        }
        break;
      case '/':
        if (code[count+1] == '/') { s = 7; }
        break;
      case '\n': /* end of line */
        if (s == 1) {
          l 
            = b;
          s = 0; /* we're resetting the buffer */
          /* time to convert */
          Variant val = resolve_Type(l);
          x.k[n]=val;
          l="";n="";b=""; /* reset everything!!!! */
        }
        else if (s == 7) { b=""; s = 0; }
        break;
      case '(':
        if (s == 1) {
          s = 2; /* begin array capture */
          b="";
        }
        else if (s == 2) { /* nested lists aren't allowed */
          writeln("error: nested lists aren't allowed");
          return;
        }
        break;
      case ',':
        if (s == 2) {
          Variant entry = resolve_Type(strip(b));
          g ~= entry;
          b="";
        }
        break;
      case ')':
        if (s == 2) {
          if (b.length > 0) { g~=resolve_Type(strip(b)); }
          s = 0;
          Variant i = g;
          x.k[n] = i;
          b="";n="";
        }
        break;
      default:
        b~=lf;break; /* add character to buffer */

    }
  }
  if (b.length > 0 && s == 1) {
    x.k[n] = resolve_Type(strip(b));
  }
}
