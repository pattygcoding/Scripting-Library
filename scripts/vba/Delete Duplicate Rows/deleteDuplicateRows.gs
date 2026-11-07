/**
 * Deletes rows whose key columns repeat an earlier row, keeping the first
 * occurrence and removing the later duplicates.
 *
 * @param {string=} keyColumns Comma-separated column letters, e.g. "A" or "A,B,C".
 *     Defaults to "A".
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @param {number=} headerRows Header rows to leave untouched. Defaults to 1.
 * @return {string} A short summary of what was removed.
 */
function deleteDuplicateRows(keyColumns, sheet, headerRows) {
  keyColumns = keyColumns || "A";
  headerRows = headerRows === undefined || headerRows === null ? 1 : headerRows;

  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var cols = parseColumns(keyColumns);
  if (cols.length === 0) {
    return "Invalid column letter";
  }

  var lastRow = ws.getLastRow();
  if (lastRow <= headerRows) {
    return "No duplicate rows";
  }

  var rowCount = lastRow - headerRows;
  var columns = cols.map(function (col) {
    return ws.getRange(headerRows + 1, col, rowCount, 1).getValues();
  });

  var seen = {};
  var victims = [];
  for (var r = 0; r < rowCount; r++) {
    var parts = columns.map(function (column) { return cellToString(column[r][0]); });
    var key = parts.join("|");
    if (seen[key]) {
      victims.push(headerRows + 1 + r);
    } else {
      seen[key] = true;
    }
  }

  for (var i = victims.length - 1; i >= 0; i--) {
    ws.deleteRow(victims[i]);
  }
  return victims.length + " duplicate row(s) deleted";
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

/** "A,B,C" -> [1, 2, 3], skipping anything that is not a letter. */
function parseColumns(text) {
  return String(text).split(",")
    .map(function (part) { return columnLetterToNumber(part.trim()); })
    .filter(function (number) { return number > 0; });
}

/** Renders a cell value for a key; null/undefined read as empty. */
function cellToString(value) {
  return value === null || value === undefined ? "" : String(value);
}
