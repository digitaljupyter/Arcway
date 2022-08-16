# Arcway

A superset of https://github.com/terminal-cs/Arc

Arc is a hackable and easy-to-use file format which gathers data by using key: value pairs.

There are no public examples of the Arc file format, but judging by the source code,
it looks something like this:

```arc
hello: world
port: 5656
```
The original Arc is very simple.

Arcway offers the same look & feel (while being backwards compatible with existing Arc formats)

## Compatibility

Despite being a superset of Arc, **ARCWAY IS NOT ARC**, simple, if you are looking
for the Arc format, you will go to the official Arc repository. If you want Arcway,
look at the official Arcway repository/websites.

Arc is not compatible with arcway-specific code, if you have a variable which is an array, it needs to be parsed USING ARCWAY, not ARC.

## Comments

Comments are `'//'`.

## Value parsing

Arcway contains variant-parsing which means that every type utilises the `Variant` type that dlang provides. This is how
it works in Arc (with the C# (object) cast)

Arcway parses every value into possible members, and also contains it's own custom datatype: **the array.**

Start an array using '(' and end one using ')'

Example:

```arcway
matrix: (
  1.0, 
  1.20, 
  1.50
)
```

And no, you can **not** nest arrays. *(this may be implemented in the future)*

```dlang
import arcway;
import std.stdio;

void main() {
  auto arcway = arcway\_init();

  arc\_to\_top(arcway, "a: 1");

  writeln(aw\_get\_value(arcway, "a")); // int(1)
}
```
