/**
 * Compares two rows of a sheet and returns the columns that differ.
 *
 * @param {number} row1 First row number, e.g. 2.
 * @param {number} row2 Second row number, e.g. 3.
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @param {boolean=} includeTimestamps When true, every column is compared; when false
 *     (default), columns whose two cells both look like SQL Server timestamps are skipped.
 * @return {string} A newline-separated report, or "No differences".
 * @customfunction
 */
function compareRows(row1, row2, sheet, includeTimestamps) {
  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var lastCol = ws.getLastColumn();
  if (lastCol === 0) {
    return "No differences";
  }
  var rowValues1 = ws.getRange(row1, 1, 1, lastCol).getValues()[0];
  var rowValues2 = ws.getRange(row2, 1, 1, lastCol).getValues()[0];

  var differences = [];
  for (var i = 0; i < lastCol; i++) {
    var a = rowValues1[i];
    var b = rowValues2[i];
    if (includeTimestamps || !(isTimestamp(a) && isTimestamp(b))) {
      if (cellToString(a) !== cellToString(b)) {
        differences.push("Column " + columnNumberToLetter(i + 1) + ": " + cellToString(a) + " vs " + cellToString(b));
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
