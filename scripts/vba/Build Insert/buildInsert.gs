/**
 * Builds one INSERT INTO statement per data row from a header row and the rows
 * below it.
 *
 * @param {string} tableName Target table, e.g. "dbo.Users".
 * @param {number} headerRow Row holding the column names.
 * @param {number} firstRow First data row.
 * @param {number=} lastRow Last data row; 0 or omitted means "to the end".
 * @param {string=} sheet Optional sheet name; defaults to the active sheet.
 * @return {string} One "INSERT INTO [table] ([cols]) VALUES (...);" per row.
 * @customfunction
 */
function buildInsert(tableName, headerRow, firstRow, lastRow, sheet) {
  var ws = resolveSheet(sheet);
  if (!ws) {
    return "Sheet not found";
  }

  var lastCol = ws.getLastColumn();
  if (lastCol === 0) {
    return "No columns found";
  }

  if (lastRow === undefined || lastRow === null || lastRow <= 0) {
    lastRow = ws.getLastRow();
  }
  if (lastRow < firstRow) {
    return "No data rows";
  }

  var headers = ws.getRange(headerRow, 1, 1, lastCol).getValues()[0];
  var columns = headers.map(function (header) {
    return "[" + cellToString(header) + "]";
  }).join(", ");

  var data = ws.getRange(firstRow, 1, lastRow - firstRow + 1, lastCol).getValues();
  var statements = data.map(function (row) {
    var values = row.map(sqlLiteral).join(", ");
    return "INSERT INTO [" + tableName + "] (" + columns + ") VALUES (" + values + ");";
  });

  return statements.length === 0 ? "No data rows" : statements.join("\n");
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

/** A cell value rendered as a SQL literal: numbers bare, text quoted, blanks NULL. */
function sqlLiteral(value) {
  if (value === null || value === undefined || value === "") {
    return "NULL";
  }
  if (value instanceof Date) {
    return "'" + formatTimestamp(value) + "'";
  }
  if (typeof value === "number") {
    return String(value);
  }
  return "'" + String(value).replace(/'/g, "''") + "'";
}

/** Formats a Date as "yyyy-mm-dd hh:mm:ss". */
function formatTimestamp(date) {
  function pad(number) {
    return (number < 10 ? "0" : "") + number;
  }
  return date.getFullYear() + "-" + pad(date.getMonth() + 1) + "-" + pad(date.getDate()) + " " +
    pad(date.getHours()) + ":" + pad(date.getMinutes()) + ":" + pad(date.getSeconds());
}

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value) {
  return value === null || value === undefined ? "" : String(value);
}
