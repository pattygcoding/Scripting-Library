-- Builds and launches a Minecraft mod client via Gradle.

local IS_WINDOWS = package.config:sub(1, 1) == "\\"

local function main()
  local skip_build = false
  for _, value in ipairs(arg) do
    if value == "--skip-build" then
      skip_build = true
    end
  end

  local gradlew = IS_WINDOWS and "gradlew.bat" or "./gradlew"
  if not skip_build then
    os.execute(gradlew .. " clean build")
  end
  os.execute(gradlew .. " runClient")
end

main()
