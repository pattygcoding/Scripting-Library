/**
 * BuildInsert  -  Office Script (TypeScript)
 *
 * Builds one INSERT INTO statement per data row from a header row and the rows
 * below it.  Run it from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const tableName = "dbo.Users";
  const headerRow = 1;
  const firstRow = 2;
  const lastRow = 0; // 0 = to the end of the data

  const sql = buildInsert(tableName, headerRow, firstRow, lastRow, workbook.getActiveWorksheet());
  console.log(sql);
}

/**
 * Builds INSERT statements for the data rows of `sheet`.
 * @param lastRow Last data row; 0 means "to the end of the data".
 */
function buildInsert(
  tableName: string,
  headerRow: number,
  firstRow: number,
  lastRow: number,
  sheet: ExcelScript.Worksheet,
): string {
  const used = sheet.getUsedRange();
  const lastCol = used.getColumnCount();
  if (lastRow <= 0) {
    lastRow = used.getRow() + used.getRowCount() - 1;
  }
  if (lastRow < firstRow) {
    return "No data rows";
  }

  const headers = sheet.getRangeByIndexes(headerRow - 1, 0, 1, lastCol).getValues()[0];
  const columns = headers.map((header) => `[${cellToString(header)}]`).join(", ");

  const data = sheet.getRangeByIndexes(firstRow - 1, 0, lastRow - firstRow + 1, lastCol).getValues();
  const statements = data.map((row) => {
    const values = row.map(sqlLiteral).join(", ");
    return `INSERT INTO [${tableName}] (${columns}) VALUES (${values});`;
  });

  return statements.length === 0 ? "No data rows" : statements.join("\n");
}

/** A cell value rendered as a SQL literal: numbers bare, text quoted, blanks NULL. */
function sqlLiteral(value: unknown): string {
  if (value === null || value === undefined || value === "") {
    return "NULL";
  }
  if (value instanceof Date) {
    return `'${formatTimestamp(value)}'`;
  }
  if (typeof value === "number") {
    return String(value);
  }
  return `'${String(value).replace(/'/g, "''")}'`;
}

/** Formats a Date as "yyyy-mm-dd hh:mm:ss". */
function formatTimestamp(date: Date): string {
  const pad = (number: number): string => (number < 10 ? "0" : "") + number;
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ` +
    `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
}

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}
