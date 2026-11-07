/**
 * ObtainSQL  -  Office Script (TypeScript)
 *
 * Builds the SELECT column list for a query out of a header row and a value row.
 * Run it from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const headerRow = 1;
  const valueRow = 2;

  const sql = obtainSql(workbook.getActiveWorksheet(), headerRow, valueRow);
  console.log(sql);
}

/**
 * Builds `value as [Header]` parts for a header row and a value row.
 * @param sheet Worksheet to read.
 * @param headerRow Row holding the column headers.
 * @param valueRow Row holding the values to keep as literals.
 */
function obtainSql(sheet: ExcelScript.Worksheet, headerRow: number, valueRow: number): string {
  const lastCol = sheet.getUsedRange().getColumnCount();
  const headers = sheet.getRangeByIndexes(headerRow - 1, 0, 1, lastCol).getValues()[0];
  const values = sheet.getRangeByIndexes(valueRow - 1, 0, 1, lastCol).getValues()[0];

  const parts: string[] = [];
  for (let i = 0; i < lastCol; i++) {
    const value = cellToString(values[i]);
    if (value !== "") {
      parts.push(`${value} as [${cellToString(headers[i])}]`);
    }
  }

  return parts.join(",\n");
}

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}
