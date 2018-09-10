# Traffic light sequence documentation

Traffic light sequence script uses the data read from `sequence.xml` to control traffic lights. It goes though the states in the same order they are written in the file and returns to the start when the last state ends. Every state in the file has three attributes: `"NS"`, `"WE"` and `"time"`. `"NS"` and `"WE"` are the colors of north-south and west-east traffic lights. They can have values `"R"` for red, `"Y"` for yellow and `"G"` for green. `"time"` is the duration of the state in milliseconds.

*Original page for this resource available via web archive: https://web.archive.org/web/20161128115520/http://crystalmv.net84.net:80/pages/scripts/tl_sequence.php*
