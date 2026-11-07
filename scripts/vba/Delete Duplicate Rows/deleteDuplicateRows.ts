/**
 * DeleteDuplicateRows  -  Office Script (TypeScript)
 *
 * Deletes rows whose key columns repeat an earlier row, keeping the first
 * occurrence and removing the later duplicates.  Run it from the Automate tab.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const keyColumns = "A";
  const headerRows = 1;

  const result = deleteDuplicateRows(keyColumns, workbook.getActiveWorksheet(), headerRows);
  console.log(result);
}

/**
 * Deletes duplicate rows of `sheet` on the composite key built from `keyColumns`.
 * @param keyColumns Comma-separated column letters, e.g. "A" or "A,B,C".
 * @param headerRows Header rows to leave untouched.
 */
function deleteDuplicateRows(
  keyColumns: string,
  sheet: ExcelScript.Worksheet,
  headerRows: number,
): string {
  const cols = parseColumns(keyColumns);
  if (cols.length === 0) {
    return "Invalid column letter";
  }

  const used = sheet.getUsedRange();
  const lastRow = used.getRow() + used.getRowCount() - 1;   // 1-based last data row
  if (lastRow <= headerRows) {
    return "No duplicate rows";
  }

  const rowCount = lastRow - headerRows;
  const columnCount = used.getColumnCount();
  const columns = cols.map((col) => sheet.getRangeByIndexes(headerRows, col - 1, rowCount, 1).getValues());

  const seen: Record<string, boolean> = {};
  const victims: number[] = [];
  for (let r = 0; r < rowCount; r++) {
    const key = columns.map((column) => cellToString(column[r][0])).join("|");
    if (seen[key]) {
      victims.push(headerRows + 1 + r);
    } else {
      seen[key] = true;
    }
  }

  for (let i = victims.length - 1; i >= 0; i--) {
    sheet.getRangeByIndexes(victims[i] - 1, 0, 1, columnCount)
      .getEntireRow()
      .delete(ExcelScript.DeleteShiftDirection.up);
  }
  return `${victims.length} duplicate row(s) deleted`;
}

/** "A,B,C" -> [1, 2, 3], skipping anything that is not a letter. */
function parseColumns(text: string): number[] {
  return text.split(",")
    .map((part) => columnLetterToNumber(part.trim()))
    .filter((number) => number > 0);
}

/** Converts a column letter ("A", "AB") to its 1-based number. */
function columnLetterToNumber(letter: string): number {
  const text = letter.toUpperCase();
  let number = 0;
  for (let i = 0; i < text.length; i++) {
    const code = text.charCodeAt(i);
    if (code < 65 || code > 90) {
      return 0;
    }
    number = number * 26 + (code - 64);
  }
  return number;
}

/** Renders a cell value for a key; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}
