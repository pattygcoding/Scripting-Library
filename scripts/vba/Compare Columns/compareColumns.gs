/**
 * Compares two columns of a sheet and returns the rows that differ.
 *
 * @param {string} column1 First column letter, e.g. "A".
 * @param {string} column2 Second column letter, e.g. "B".
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @param {boolean=} includeTimestamps When true, every row is compared; when false
 *     (default), rows whose two cells both look like SQL Server timestamps are skipped.
 * @return {string} A newline-separated report, or "No differences".
 * @customfunction
 */
function compareColumns(column1, column2, sheet, includeTimestamps) {
  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var col1 = columnLetterToNumber(column1);
  var col2 = columnLetterToNumber(column2);
  if (!col1 || !col2) {
    return "Invalid column letter";
  }

  var lastRow = ws.getLastRow();
  if (lastRow === 0) {
    return "No differences";
  }
  var colValues1 = ws.getRange(1, col1, lastRow, 1).getValues();
  var colValues2 = ws.getRange(1, col2, lastRow, 1).getValues();

  var differences = [];
  for (var i = 0; i < lastRow; i++) {
    var a = colValues1[i][0];
    var b = colValues2[i][0];
    if (includeTimestamps || !(isTimestamp(a) && isTimestamp(b))) {
      if (cellToString(a) !== cellToString(b)) {
        differences.push("Row " + (i + 1) + ": " + cellToString(a) + " vs " + cellToString(b));
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

/** Converts a column letter ("A", "AB") to its 1-based number. */
function columnLetterToNumber(letter) {
  var text = String(letter).toUpperCase();
  var number = 0;
  for (var i = 0; i < text.length; i++) {
    var code = text.charCodeAt(i);
    if (code < 65 || code > 90) {
      return 0;
    }
    number = number * 26 + (code - 64);
  }
  return number;
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
