/**
 * Trims the leading and trailing spaces from every cell in a range, in place.
 *
 * @param {string=} address A range ("A1:C50"), a whole column ("A"), or a name.
 *     Defaults to "A".
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @return {string} A short summary of how many cells changed.
 */
function trimWhitespace(address, sheet) {
  address = address || "A";

  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var range = resolveRange(ws, address);
  if (!range) {
    return "Invalid range: " + address;
  }

  var values = range.getValues();
  var changed = 0;
  for (var r = 0; r < values.length; r++) {
    for (var c = 0; c < values[r].length; c++) {
      var text = cellToString(values[r][c]);
      if (text !== "" && text.trim() !== text) {
        values[r][c] = text.trim();
        changed++;
      }
    }
  }
  if (changed > 0) {
    range.setValues(values);
  }
  return changed + " cell(s) trimmed";
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

/** A range address, or a bare column letter expanded to that column's used rows. */
function resolveRange(ws, address) {
  var text = String(address).trim();
  if (text === "") {
    return null;
  }
  if (/^[A-Za-z]{1,3}$/.test(text)) {
    var lastRow = ws.getLastRow();
    if (lastRow < 1) {
      lastRow = 1;
    }
    return ws.getRange(1, columnLetterToNumber(text), lastRow, 1);
  }
  try {
    return ws.getRange(text);
  } catch (error) {
    return null;
  }
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
