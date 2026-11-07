#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates a SQL script to search for a column name across a database.

require 'optparse'

MAGENTA = "\e[35m"
RESET = "\e[0m"

TEMPLATE = <<~SQL
  WITH ColumnEntries AS (
      SELECT
          C.TABLE_SCHEMA,
          C.TABLE_NAME,
          C.COLUMN_NAME,
          COUNT(*) AS EntryCount
      FROM
          INFORMATION_SCHEMA.COLUMNS C
      JOIN
          INFORMATION_SCHEMA.TABLES T
      ON
          C.TABLE_NAME = T.TABLE_NAME
          AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
      WHERE
          C.COLUMN_NAME LIKE '%__COLUMN__%'
          AND T.TABLE_TYPE = 'BASE TABLE'
      GROUP BY
          C.TABLE_SCHEMA, C.TABLE_NAME, C.COLUMN_NAME
  )
  SELECT
      C.TABLE_SCHEMA AS SchemaName,
      C.TABLE_NAME AS TableName,
      C.COLUMN_NAME AS ColumnName,
      CASE
          WHEN E.EntryCount > 0 THEN 'True'
          ELSE 'False'
      END AS HasEntries
  FROM
      INFORMATION_SCHEMA.COLUMNS C
  LEFT JOIN
      ColumnEntries E
  ON
      C.TABLE_SCHEMA = E.TABLE_SCHEMA
      AND C.TABLE_NAME = E.TABLE_NAME
      AND C.COLUMN_NAME = E.COLUMN_NAME
  WHERE
      C.COLUMN_NAME LIKE '%__COLUMN__%'
  ORDER BY
      SchemaName;
SQL

def main
  column = nil
  OptionParser.new do |opts|
    opts.banner = 'Usage: gensql-col.rb -c COLUMN'
    opts.on('-c', '--column COLUMN', 'Column name (or fragment) to search for') { |c| column = c }
  end.parse!
  abort 'Error: -c/--column is required.' if column.nil?

  puts "#{MAGENTA}#{TEMPLATE.gsub('__COLUMN__', column)}#{RESET}"
end

main if __FILE__ == $PROGRAM_NAME
