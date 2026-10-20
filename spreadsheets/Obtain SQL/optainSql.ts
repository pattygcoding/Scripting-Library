function main(workbook: ExcelScript.Workbook, headerRow: number, valueRow: number): string {
  // Get the active worksheet
  let sheet = workbook.getActiveWorksheet();
  
  // Initialize an empty array to hold the SQL parts
  let sqlParts: string[] = [];
  
  // Get the header row and the corresponding values row
  let headers = sheet.getRangeByIndexes(headerRow - 1, 0, 1, sheet.getUsedRange().getColumnCount()).getValues()[0];
  let values = sheet.getRangeByIndexes(valueRow - 1, 0, 1, sheet.getUsedRange().getColumnCount()).getValues()[0];
  
  // Loop through the headers and values to build the SQL string
  for (let i = 0; i < headers.length; i++) {
    if (values[i] !== "") {  // Ensure that empty values are not included
      sqlParts.push(`${values[i]} as [${headers[i]}]`);
    }
  }
  
  // Join the parts with a comma and newline and return the resulting string
  return sqlParts.join(",\n");
}
