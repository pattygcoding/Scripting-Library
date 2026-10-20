function obtainSql(headerRow, valueRow, sheet) {
  // Get the active sheet
  sheet = sheet || SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  
  // Initialize an empty array to hold the SQL parts
  var sqlParts = [];
  
  // Get the header row and the corresponding values row
  var headers = sheet.getRange(headerRow, 1, 1, sheet.getLastColumn()).getValues()[0];
  var values = sheet.getRange(valueRow, 1, 1, sheet.getLastColumn()).getValues()[0];
  
  // Loop through the headers and values to build the SQL string
  for (var i = 0; i < headers.length; i++) {
    if (values[i] !== "") {  // Ensure that empty values are not included
      sqlParts.push(values[i] + " as [" + headers[i] + "]");
    }
  }
  
  // Join the parts with a comma and newline and return the resulting string
  return sqlParts.join(",\n");
}
