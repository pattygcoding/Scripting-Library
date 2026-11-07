/**
 * FindDuplicates  -  Office Script (TypeScript)
 *
 * Lists the values that appear more than once in a column, with the rows each one
 * is on.  Run it from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const column = "A";

  const report = findDuplicates(column, workbook.getActiveWorksheet());
  console.log(report);
}

/**
 * Lists the values that appear more than once in `column`, with their rows.
 */
function findDuplicates(column: string, sheet: ExcelScript.Worksheet): string {
  const col = columnLetterToNumber(column);
  if (col === 0) {
    return "Invalid column letter";
  }

  const lastRow = sheet.getUsedRange().getRowCount();
  const values = sheet.getRangeByIndexes(0, col - 1, lastRow, 1).getValues();

  const rowsByValue: Record<string, number[]> = {};
  const order: string[] = [];
  for (let r = 0; r < lastRow; r++) {
    const key = cellToString(values[r][0]);
    if (key === "") {
      continue;
    }
    if (!rowsByValue[key]) {
      rowsByValue[key] = [];
      order.push(key);
    }
    rowsByValue[key].push(r + 1);
  }

  const report: string[] = [];
  order.forEach((key) => {
    if (rowsByValue[key].length > 1) {
      report.push(`${key} (rows ${rowsByValue[key].join(", ")})`);
    }
  });

  return report.length === 0 ? "No duplicates" : report.join("\n");
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

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}
