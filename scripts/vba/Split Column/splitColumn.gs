/**
 * Splits one column on a delimiter and writes the parts into the columns to its
 * right.
 *
 * @param {string=} column Column letter to split. Defaults to "A".
 * @param {string=} delimiter Text to split on. Defaults to ",".
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @return {string} A short summary of how many columns were written.
 */
function splitColumn(column, delimiter, sheet) {
  column = column || "A";
  delimiter = delimiter === undefined || delimiter === null ? "," : delimiter;

  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var col = columnLetterToNumber(column);
  if (!col) {
    return "Invalid column letter: " + column;
  }

  var lastRow = ws.getLastRow();
  if (lastRow < 1) {
    return "Nothing to split";
  }

  var values = ws.getRange(1, col, lastRow, 1).getValues();
  var split = values.map(function (row) {
    return cellToString(row[0]).split(delimiter);
  });
  var maxParts = split.reduce(function (max, parts) {
    return Math.max(max, parts.length);
  }, 1);

  if (maxParts <= 1) {
    return "Nothing to split";
  }

  var output = split.map(function (parts) {
    var row = [];
    for (var i = 0; i < maxParts; i++) {
      row.push(i < parts.length ? parts[i].trim() : "");
    }
    return row;
  });

  ws.getRange(1, col + 1, lastRow, maxParts).setValues(output);
  return maxParts + " column(s) written from " + String(column).toUpperCase();
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
