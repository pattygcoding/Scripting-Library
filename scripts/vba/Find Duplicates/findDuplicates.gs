/**
 * Lists the values that appear more than once in a column, with the rows each one
 * is on.
 *
 * @param {string} column Column letter to scan, e.g. "A".
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @return {string} A newline-separated report, or "No duplicates".
 * @customfunction
 */
function findDuplicates(column, sheet) {
  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var col = columnLetterToNumber(column);
  if (!col) {
    return "Invalid column letter";
  }

  var lastRow = ws.getLastRow();
  if (lastRow === 0) {
    return "No duplicates";
  }

  var values = ws.getRange(1, col, lastRow, 1).getValues();

  var rowsByValue = {};
  var order = [];
  for (var r = 0; r < lastRow; r++) {
    var key = cellToString(values[r][0]);
    if (key === "") {
      continue;
    }
    if (!rowsByValue[key]) {
      rowsByValue[key] = [];
      order.push(key);
    }
    rowsByValue[key].push(r + 1);
  }

  var report = [];
  order.forEach(function (key) {
    if (rowsByValue[key].length > 1) {
      report.push(key + " (rows " + rowsByValue[key].join(", ") + ")");
    }
  });

  return report.length === 0 ? "No duplicates" : report.join("\n");
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

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value) {
  return value === null || value === undefined ? "" : String(value);
}
