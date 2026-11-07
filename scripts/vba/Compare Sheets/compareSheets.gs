/**
 * Compares two sheets cell by cell over their shared top-left region.
 *
 * @param {string} sheet1 First sheet name.
 * @param {string} sheet2 Second sheet name.
 * @param {boolean=} includeTimestamps When true, every cell is compared; when false
 *     (default), cells whose two values both look like SQL Server timestamps are skipped.
 * @return {string} A newline-separated report, or "No differences".
 * @customfunction
 */
function compareSheets(sheet1, sheet2, includeTimestamps) {
  var ws1 = resolveSheet(sheet1);
  var ws2 = resolveSheet(sheet2);
  if (!ws1 || !ws2) {
    return "Sheet not found";
  }

  var rows = Math.min(ws1.getLastRow(), ws2.getLastRow());
  var cols = Math.min(ws1.getLastColumn(), ws2.getLastColumn());
  if (rows === 0 || cols === 0) {
    return "No differences";
  }

  var data1 = ws1.getRange(1, 1, rows, cols).getValues();
  var data2 = ws2.getRange(1, 1, rows, cols).getValues();

  var differences = [];
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      var a = data1[r][c];
      var b = data2[r][c];
      if (includeTimestamps || !(isTimestamp(a) && isTimestamp(b))) {
        if (cellToString(a) !== cellToString(b)) {
          differences.push("Cell " + columnNumberToLetter(c + 1) + (r + 1) + ": " + cellToString(a) + " vs " + cellToString(b));
        }
      }
    }
  }

  return differences.length === 0 ? "No differences" : differences.join("\n");
}

// --- Helpers, shared by the spreadsheet scripts ----------------------------

/** Resolves a sheet name, a Sheet object, or nothing (the active sheet). */
function resolveSheet(sheet) {
  if (sheet && typeof sheet.getRange === "function") {
    return sheet;
  }
  var book = SpreadsheetApp.getActiveSpreadsheet();
  if (typeof sheet === "string" && sheet !== "") {
    return book.getSheetByName(sheet);
  }
  return book.getActiveSheet();
}

/** Converts a 1-based column number to its letter (1 -> "A", 28 -> "AB"). */
function columnNumberToLetter(number) {
  var letter = "";
  var value = number;
  while (value > 0) {
    var remainder = (value - 1) % 26;
    letter = String.fromCharCode(65 + remainder) + letter;
    value = Math.floor((value - 1) / 26);
  }
  return letter;
}

/** True for a value shaped like a SQL Server "Mon Jan 01 2024 12:00:00 GMT+0000 (GMT+00:00)". */
function isTimestamp(value) {
  return typeof value === "string" &&
    /^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$/.test(value);
}

/** Renders a cell value for the report; null/undefined read as empty. */
function cellToString(value) {
  return value === null || value === undefined ? "" : String(value);
}
