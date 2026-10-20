// Generates public/scripts-data.js from the real repository: the dashboard is a
// viewer for what is actually committed, so this walks the six language folders,
// reads each script's source and the README that sits beside it, and writes one
// payload the app can read without a fetch.  `npm run data` runs it, and the build
// runs it again, so a script added to a folder appears on the site without an app
// change.
import { execFileSync } from "node:child_process";
import { existsSync, readFileSync, readdirSync, statSync, writeFileSync } from "node:fs";
import { dirname, extname, join } from "node:path";
import { fileURLToPath } from "node:url";

// tools/ -> the repository root.
const ROOT = dirname(dirname(fileURLToPath(import.meta.url)));

// The language folders, in the order the README lists them.  `primary` is the order
// a folder's files are preferred in: the spreadsheet scripts ship a .vba, a .gs and
// an experimental .ts, and the .vba is the one this library is named for.
const LANGUAGES = [
    { folder: "bash", name: "Bash", extension: ".sh", prism: "language-bash", primary: [".sh"] },
    { folder: "lua", name: "Lua", extension: ".lua", prism: "language-lua", primary: [".lua"] },
    { folder: "powershell", name: "PowerShell", extension: ".ps1", prism: "language-powershell", primary: [".ps1"] },
    { folder: "python", name: "Python", extension: ".py", prism: "language-python", primary: [".py"] },
    { folder: "ruby", name: "Ruby", extension: ".rb", prism: "language-ruby", primary: [".rb"] },
    { folder: "vba", name: "VBA", extension: ".vba", prism: "language-visual-basic", primary: [".vba", ".gs", ".ts"] },
];

const DEFAULT_REPOSITORY = "https://github.com/pattygcoding/Scripting-Library";

// Read a file as text.  Line endings are normalised to LF: git stores LF, but a
// Windows checkout with `core.autocrlf=true` hands back CRLF, and the generator must
// produce the same payload on a developer's machine and on the Linux runner.
function readText(path) {
    return readFileSync(path, "utf8").replace(/^\uFEFF/, "").replace(/\r\n/g, "\n");
}

// A folder name as an address slug: `Clear Git` -> `clear-git`, `Update GIt` ->
// `update-git`.  The result always matches the 404 shim's slug pattern, so a deep
// link can be typed by hand.
function slug(text) {
    return text
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "");
}

function pickPrimary(sources, preferred) {
    for (const extension of preferred) {
        const match = sources.find((file) => file.toLowerCase().endsWith(extension));
        if (match) {
            return match;
        }
    }
    return sources[0];
}

// One script folder -> one item.  `docs` is absent for the folders that ship no
// README, which is what hides the Documentation tab for them.
function collectScripts(language) {
    const languageDir = join(ROOT, language.folder);
    if (!existsSync(languageDir)) {
        return [];
    }
    const items = [];
    for (const entry of readdirSync(languageDir).sort(compare)) {
        if (entry.startsWith(".")) {
            continue;
        }
        const scriptDir = join(languageDir, entry);
        if (!statSync(scriptDir).isDirectory()) {
            continue;
        }
        const files = readdirSync(scriptDir)
            .filter((file) => !file.startsWith("."))
            .filter((file) => statSync(join(scriptDir, file)).isFile())
            .sort(compare);
        const sources = files.filter((file) => file.toLowerCase() !== "readme.md");
        if (sources.length === 0) {
            continue;
        }
        const primary = pickPrimary(sources, language.primary);
        const others = sources.filter((file) => file !== primary);
        const readme = files.find((file) => file.toLowerCase() === "readme.md");
        items.push({
            id: language.folder + "-" + slug(entry),
            name: entry,
            language: language.name,
            prism: language.prism,
            file: language.folder + "/" + entry + "/" + primary,
            folder: language.folder + "/" + entry,
            extension: extname(primary).toLowerCase(),
            ...(others.length > 0 ? { note: "Also in this folder: " + others.join(", ") + "." } : {}),
            ...(readme ? { docs: readText(join(scriptDir, readme)) } : {}),
            code: readText(join(scriptDir, primary)),
        });
    }
    return items;
}

// Code-unit order, so the payload does not depend on the machine's locale.
function compare(a, b) {
    const left = a.toLowerCase();
    const right = b.toLowerCase();
    if (left === right) {
        return a < b ? -1 : a > b ? 1 : 0;
    }
    return left < right ? -1 : 1;
}

// `git remote get-url origin` in CI (actions/checkout leaves origin set), so a fork
// marks its own repository; GITHUB_REPOSITORY covers a checkout without a remote, and
// the committed default covers a source tarball.
function repositoryUrl() {
    try {
        const remote = execFileSync("git", ["remote", "get-url", "origin"], {
            cwd: ROOT,
            encoding: "utf8",
            stdio: ["ignore", "pipe", "ignore"],
        }).trim();
        const web = remote
            .replace(/^git@([^:]+):/, "https://$1/")
            .replace(/^ssh:\/\/git@([^/]+)\//, "https://$1/")
            .replace(/\.git$/, "");
        if (web.startsWith("http")) {
            return web;
        }
    } catch {
        // no git, or no origin: fall through
    }
    const repoSlug = process.env.GITHUB_REPOSITORY;
    return repoSlug ? "https://github.com/" + repoSlug : DEFAULT_REPOSITORY;
}

// The branch the per-folder GitHub links point at.  A CI checkout is detached, so
// GITHUB_REF_NAME wins there; otherwise ask git.
function branchName() {
    if (process.env.GITHUB_REF_NAME) {
        return process.env.GITHUB_REF_NAME;
    }
    try {
        const branch = execFileSync("git", ["rev-parse", "--abbrev-ref", "HEAD"], {
            cwd: ROOT,
            encoding: "utf8",
            stdio: ["ignore", "pipe", "ignore"],
        }).trim();
        return branch || "main";
    } catch {
        return "main";
    }
}

// Two folders in one language can slugify alike (`Update GIt` / `Update Git`), which
// would make two rows share an address; the later one is suffixed rather than
// dropped, so nothing in the repository goes unlisted.
function uniqueIds(items) {
    const seen = new Set();
    for (const item of items) {
        let id = item.id;
        let suffix = 2;
        while (seen.has(id)) {
            id = item.id + "-" + suffix;
            suffix += 1;
        }
        item.id = id;
        seen.add(id);
    }
}

function main() {
    const languages = [];
    const scripts = [];
    for (const language of LANGUAGES) {
        const items = collectScripts(language);
        if (items.length === 0) {
            continue;
        }
        languages.push({
            name: language.name,
            extension: language.extension,
            prism: language.prism,
            count: items.length,
        });
        scripts.push(...items);
    }
    uniqueIds(scripts);

    const payload = {
        meta: {
            updated: new Date().toISOString().slice(0, 10),
            languageCount: languages.length,
            scriptCount: scripts.length,
            documentedCount: scripts.filter((script) => script.docs).length,
            repository: repositoryUrl(),
            branch: branchName(),
        },
        languages,
        scripts,
    };

    const banner =
        "// Generated by tools/generate-data.mjs from the script folders - do not edit by hand.\n" +
        "// Regenerate with `npm run data` (the build runs it too).\n";
    writeFileSync(
        join(ROOT, "public", "scripts-data.js"),
        banner + "window.SCRIPTING_LIBRARY_DATA = " + JSON.stringify(payload, null, 4) + ";\n",
        "utf8",
    );

    const counts = languages.map((language) => language.name + " " + language.count).join(", ");
    console.log(
        "scripts-data.js: " + payload.meta.scriptCount + " scripts in " + payload.meta.languageCount +
        " languages (" + counts + "); " + payload.meta.documentedCount + " documented",
    );
}

main();
