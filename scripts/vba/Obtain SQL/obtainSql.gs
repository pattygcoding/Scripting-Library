/**
 * Builds the SELECT column list for a query out of a header row and a value row:
 * value1 as [Header1], value2 as [Header2], ...
 *
 * @param {number} headerRow Row holding the column headers.
 * @param {number} valueRow Row holding the values to keep as literals.
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @return {string} The column list, comma-and-newline separated (blanks skipped).
 * @customfunction
 */
function obtainSql(headerRow, valueRow, sheet) {
  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var lastCol = ws.getLastColumn();
  if (lastCol === 0) {
    return "";
  }

  var headers = ws.getRange(headerRow, 1, 1, lastCol).getValues()[0];
  var values = ws.getRange(valueRow, 1, 1, lastCol).getValues()[0];

  var parts = [];
  for (var i = 0; i < lastCol; i++) {
    var value = cellToString(values[i]);
    if (value !== "") {
      parts.push(value + " as [" + cellToString(headers[i]) + "]");
    }
  }

  return parts.join(",\n");
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

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value) {
  return value === null || value === undefined ? "" : String(value);
}
